#!/bin/bash
show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Scenario 1 - Slave failure ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Scenario 2 - Master failure${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Scenario 3 - Replication Failure${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} Scenario 4 - Master Failure 2${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5)${MENU} Scenario 5 - Failsafe${NORMAL}"
    echo -e "${MENU}**${NUMBER} 6)${MENU} Reset Hosts ${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt
}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

function s1() {
   echo "Setting up scenario 1"
   echo "service db2/mysql stop"|cctrl > /dev/null
}

function s2() {
   echo "Setting up scenario 2"
   echo "service db1/mysql stop"|cctrl > /dev/null
}

function s3() {
   echo "Setting up scenario 3........"
   tpm connector -e\"drop table if exists test.people\"
   SQL1="create table test.people(empno int, firstname char(20));alter table test.people add primary key (empno);"
   tpm connector -e\"$SQL1\"
   SQL2="insert into test.people values (1,'fred'),(2,'bill')";
   SQL3="insert into test.people values (3,'joe')";
   SQL4="insert into test.people values (3,'sarah')";
   tpm connector -e\"$SQL2\"
   tpm mysql --host db2 -e\"$SQL3\"
   tpm connector -e\"$SQL4\"
}

function s4() {
   echo "Setting up scenario 4"
   echo "set policy automatic"|cctrl > /dev/null
   echo "switch to db2"|cctrl > /dev/null
   echo " -- step 1 complete"
   echo "datasource db1 backup"|cctrl > /dev/null
   echo " -- step 2 complete"
   echo "switch to db1"|cctrl > /dev/null
   echo " -- step 3 complete"
   echo "service db1/mysql stop"|cctrl > /dev/null
   echo " -- step 4 complete"
   sleep 10
   sudo service mysql start > /dev/null
   echo " -- step 5 complete"
   replicator stop > /dev/null
   SQL1="update tungsten_east.trep_commit_seqno set seqno=seqno+100"
   tpm mysql -e\"$SQL1\"
   replicator start > /dev/null
}

function s5() {
   echo "Setting up scenario 5........"
   ssh db2 manager stop > /dev/null
   ssh db3 manager stop > /dev/null
   sleep 60
}

function reseth() {
   echo "Resetting Hosts........"
   ssh db2 manager start > /dev/null
   ssh db3 manager start > /dev/null
   tpm reset
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then
            exit;
    else
        case $opt in
        1) clear;
        s1
        show_menu;
        ;;
        2) clear;
        s2
        show_menu;
        ;;

        3) clear;
            s3
            show_menu;
            ;;

        4) clear;
        s4
        show_menu;
        ;;
        6) clear;
           reseth
           show_menu;
            ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done
