#!/usr/bin/bash
PS3="your choice >> "

mkdir DBs 2>> ./.error.log
clear
echo "			   +=====================+"
echo "			   |   Welcome To DBMS   |"
echo "			   +=====================+"
echo -e "\nAUTHOR\n\tWritten by:Muhammad Elbaramawy & Muhammad Taha.\n\tOpen source applications development ITI Mansoura Branch.\n\tContact us on muhammmadtahagad@gmail.com and mohamed77bermawy@gmail.com\n\nCOPYRIGHT\n\tCopyright © 2021 Free Software Foundation, Inc.\n\tLicense GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n\tThis is free software: you are free to change and redistribute it.  \n\tThere is NO WARRANTY, to the extent permitted by law.\n\n"

function Select_All_Data {

	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi
	typeset -i index=0
	typeset -i size
	typeset row=""
        for tableName in `ls`
        do
                if test $tableName = $table_name
                then
			echo " "
			echo "Table Selected successfully"
			echo " "

			array=(`awk -F":" '{if (NR>=3) print $3}' metaData_$tableName`)
			
			size=${#array[*]}
			
			index=1
			row=${array[0]}
			while (($index < $size))
			do
			row=$row': \ \ :'${array[index]}
				((index =$index+1))
			done
			echo $row
			echo "========================================"
			echo " "

			sed 's/:/: \ \ \ :/g' $tableName
			echo "========================================"
			echo " "
			return 0
		fi

        done

	echo " "
	echo "Table Not exists!!!"
	echo " "

}

function Select_A_Spacific_Row {

	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi
	typeset -i index=0
	typeset -i size
	typeset row=""
        for tableName in `ls`
        do
            if test $tableName = $table_name
            then
				echo " "
				echo "Table Selected successfully"
				echo " "

				array=(`awk -F":" '{if (NR>=3) print $3}' metaData_$tableName`)

				read -p "Enter tne value of the primary key [ ${array[0]} ] to diplay its row : " selected_value

				arr=(`awk -F":" '{if ($1=="'$selected_value'") print $0}' $tableName`)
				#echo ${arr[*]}
				if test ${#arr[*]} = 0
				then
					echo " "
					echo " Invalid Input!!!"
					echo " "
					return 1
				fi
				echo ${arr[*]} > .temp
				size=${#array[*]}
				index=1
				row=${array[0]}
				while (($index < $size))
				do
				row=$row': \ \ :'${array[index]}
					((index =$index+1))
				done
				echo $row
				echo "========================================"
				echo " "
				sed 's/:/: \ \ \ :/g' .temp
				echo " "
				echo "========================================"
				echo " "
				rm -f .temp
				return 0
			fi

        done

	echo " "
	echo "Table Not exists!!!"
	echo " "
	return 1

}


function Select_A_Spacific_Column {

	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi
	typeset -i index=0
	typeset -i num=1
	typeset -i size
	typeset temp=""
	typeset row=""
         for tableName in `ls`
         do
             if test $tableName = $table_name
             then
	
				echo " "
				echo "Table Selected successfully"
				echo " "

				array=(`awk -F":" '{if (NR>=3) print $3}' metaData_$tableName`)

				index=0
				while (($index < ${#array[*]}))
				do
					
					echo $num " >> " ${array[index]}
					((index =$index+1))
					((num =$num+1))
				done
				echo " "
				read -p "Enter tne number of column that you want to select : " number_column

				if test $number_column -lt 1 -o $number_column -gt ${#array[*]} 
				then
					echo " "
					echo "The Number of Columns Doesn't exists!!!"
					echo " "
					return 1
				fi

				((number_column =$number_column-1))
				echo ${array[number_column]}
				echo "============"
				echo " "
				((number_column =$number_column+1))
				awk -F":" '{print $'$number_column' }' $tableName
				echo " "
				
				return 0
			fi

        done

	echo " "
	echo "Table Not exists!!!"
	echo " "
	return 1
	
}



function Select_From_Table {

	echo " "
	select table_select in "Select All Data " "Select a spacific row " "Select a spacific column" "Back"
	do
		case $REPLY in
		1) Select_All_Data
			;;
		2) Select_A_Spacific_Row
			;;
		3) Select_A_Spacific_Column
			;;
		4) Table_Menu
			;;
		esac
		echo " "
	done

}


function Delete_From_table {
	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi
	typeset -i index=0
	typeset -i size
	typeset row=""
        for tableName in `ls`
        do
            if test $tableName = $table_name
            then
				echo " "
				echo "Table Selected successfully"
				echo " "

				array=(`awk -F":" '{if (NR==3) print $3}' metaData_$tableName`)

				read -p "Enter tne value of [ ${array[*]} ] to delete its row : " delete_value

				arr=(`awk -F":" '{if ($1=="'$delete_value'") print NR}' $tableName`)
				#echo ${arr[*]}
				if test ${#arr[*]} = 0
				then
					echo " "
					echo " Invalid Input!!!"
					echo " "
					return 1
				fi
				read -p "Are you want to delete this row (y or n) ? " inputchar
                if test $inputchar = "y"
                then
					sed ''${arr[0]}'d' $tableName > .temp
					cp .temp $tableName
					rm -f .temp
					echo " "
					echo "row Deleted successfully"
					echo " "
					return 0				
				fi
				echo " "
				echo "row Not Deleted!!!"
				echo " "
				return 1
			
			fi

        done

	echo " "
	echo "Table Not exists!!!"
	echo " "
	return 1	
}


function Insert_Into_Table {
	
	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi
	typeset -i index=1
	typeset -i size
	typeset row=""
	typeset inputarray[0]
        for tableName in `ls`
        do
            if test $tableName = $table_name
            then
				echo " "
				echo "Table Selected successfully"
				echo " "
				echo "===================================="
				echo "The First Column is the peimary Key"
				echo "===================================="
				echo " "
				array=(`awk -F":" '{if (NR>=3) print $3}' metaData_$tableName`)

				arr=(`awk -F":" '{print $1}' $tableName`)
				
				size=${#array[*]}

				read -p "Enter the value of column ${array[0]} : " input

				if test -z $input
				then
					echo " "
					echo "Primary Key Cann't be Null!!!"
					echo " "
					return 1
				elif test ${#arr[*]} -eq 0
				then
					
					inputarray[0]=$input
					while (($index < $size))
					do
						echo "+++++++++++++++++++++++++++++++++++++++++++++"
						read -p "Enter the value of column ${array[index]} : " inputarray[index]
						((index =$index+1))
					done
				else

					index=0
					while (($index < ${#arr[*]}))
					do
						if test $input = ${arr[index]}
						then
							echo " "
							echo "Primary Key must be unique!!!"
							echo " "
							return 1
						fi
						((index =$index+1))
					done

					index=1
					
					inputarray[0]=$input
					while (($index < $size))
					do
						read -p "Enter the value of column ${array[index]} : " inputarray[index]
						((index =$index+1))
					done
				fi
				
				index=1
				row=${inputarray[0]}
				while (($index < $size))
				do
				row=$row":"${inputarray[index]}
					((index =$index+1))
				done
				echo " "
				echo $row >> $tableName
				echo "Row inserted successfully"
				echo " "
				cat $tableName
				echo " "
				return 0
			fi

        done

	echo " "
	echo "Table Not exists!!!"
	echo " "


}

function Create_Table {
	
	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi

	for tableName in `ls`
	do
		if test $tableName = $table_name
		then
			echo " "
			echo "Table already exists!!!"
			echo " "
			return 1
		fi
	done
	
	touch $table_name
    	touch metaData_$table_name
	
	typeset -i col_number
	read -p "Enter Number of Columns : " col_number

	echo "general : Table Name : "$table_name >> metaData_$table_name
	echo "general : Number of Columns : "$col_number >> metaData_$table_name
	
	typeset -i index=1

	while test $index -le $col_number
	do	
		if test $index -eq 1
		then
			echo " "
			echo "===================================="
			echo "The First Column is the peimary Key"
			echo "===================================="
			echo " "
	 		read -p "Enter column name of $index : " col_name
			echo "+++++++++++++++++++++++++++++++++++++++++++"
			echo "primary key : $index : "$col_name >> metaData_$table_name
		else
			read -p "Enter column name of $index : " col_name
			echo "+++++++++++++++++++++++++++++++++++++++++++"
            echo "Not primary key : $index : "$col_name >> metaData_$table_name

		fi
		((index = $index+1))
	done
	echo " "
        echo "Table Created Successfully"
	echo " "
        return 0

}

function List_Tables {

	echo "Tables List : "
        echo '=============='
	
	typeset count="$(ls | wc -l)"

        if test $count -eq 0
        then
                echo " "
                echo "Impty!!!"
                echo " "
                return 1
        fi


        typeset list_count

        for lscount in `ls | sed '/^metaData_/d'
`
        do
                if test -z $lscount
                then
                        echo "Empty!!!"
                        break
                else
                        ((list_count = $list_count+1))
                        echo $list_count ": " $lscount
                fi

        done
        echo " "

}

function Drop_Table {

	read -p "Enter Table Name : " table_name
	if test -z $table_name
	then
		echo " "
		echo "Enter The Table Name!!!"
		echo " "
		return 1
	fi

        for tableName in `ls`
        do
                if test $tableName = $table_name
                then
			read -p "Are you want to delete $tableName (y or n) ? " inputchar
                        if test $inputchar = "y"
                        then
				rm -f $tableName
				rm -f metaData_$tableName 
				echo " "
        	                echo "Table deleted successfully"
	                        echo " "
				return 0
			fi
                fi
        done
	echo " "
        echo "Table Not Deleted!!!"
        echo " "


}

function Init {

	for initialfolder in `ls`
	do
		if test $initialfolder = "DBs"
		then
			return 0
		fi
	done
	mkdir DBs
	return 1
}


function Table_Menu {
	
echo "Table Menu : "
echo "============"
select table_menu in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "back" "exit"
do
    case $REPLY in
    1) Create_Table
                ;;
    2) List_Tables
                ;;
	3) Drop_Table
                ;;
    4) Insert_Into_Table
                ;;
	5) Select_From_Table
		;;
	6) Delete_From_table
		;;
	7) cd ../..
		Init
		Main_Menu
		;;		
    8) exit
        ;;
esac
done


}


function Create_Database {
	
	read -p "Enter DB Name : " inputDB
	if test -z $inputDB
	then
		echo " "
		echo "Enter The DB Name!!!"
		echo " "
		return 0
	fi

	for createDB in `ls DBs`
	do
		if test $createDB = $inputDB
		then
			echo " "
			echo 'DB exists before!!!'
			echo " "
			return 0
		fi
	done
	mkdir DBs/$inputDB
	return 1
}

function List_Database {

	echo "DataBase List : "
	echo '================='
	typeset count="$(ls DBs/ | wc -l)"

	if test $count -eq 0
	then
		echo " "
		echo "Impty!!!"
		echo " "
		return 1
	fi

	typeset	list_count

	for lscount in `ls DBs`
	do
		if test $lscount = "index.sh"
		then
			continue
		else
			((list_count = $list_count+1))
			echo $list_count ": " $lscount
		fi

	done
	echo " "
}

function Connect_To_Database {
		
	read -p "Enter DB Name to Connect : " connectDBinput
	
		if test -z $connectDBinput
	then
		echo " "
		echo "Enter The DB Name!!!"
		echo " "
		return 0
	fi
        for connectDB in `ls DBs`
        do
                if test $connectDB = $connectDBinput
                then
                        read -p "Are you want to connect to $connectDB (y or n) ? " inputchar
                        if test $inputchar = "y"
                        then
                                cd DBs/$connectDB
				echo " "
				echo "Connecting..."
				sleep 3
                                echo $connectDB "connected successfully"
				echo " "
				Table_Menu
                                return 0
                        else
				echo " "
                                echo $connectDB "Not connected!!!"
				echo " "
                                return 0
                        fi
                fi
        done
	echo " "
        return 1


}

function Drop_Database {
	
	read -p "Enter DB Name : " dropDBinput
	if test -z $dropDBinput
	then
		echo " "
		echo "Enter The DB Name!!!"
		echo " "
		return 0
	fi

        for dropDB in `ls DBs`
        do
		if test $dropDB = "index.sh"
		then
			continue

                elif test $dropDB = $dropDBinput
                then
			read -p "Are you sure to Drop $dropDB (y or n) ? " inputchar
			if test $inputchar = "y" 
			then
                        	rm -rf DBs/$dropDB
				echo " "
			        echo $dropDB "Droped successfully"
				echo " "	
                        	return 0
			else
				echo " "
				echo $dropDB "Not Droped!!!"
				echo " "
				return 0
			fi
	        fi
        done
	echo " "
	return 1
	
}


function Main_Menu {
echo "Main Menu : "
echo "============"

select main_menu in "Create Database" "List Databases" "Connect To Databases" "Drop Database" "exit"
do

	case $REPLY in 
	1) Create_Database
		if test $? = "1"
                then
			echo " "
                        echo "DB created successfully"
			echo " "
                fi
		;;
	2) List_Database
		;;
	3) Connect_To_Database
		if test $? = "1"
                then
			echo "Connecting..."
			sleep 3
                        echo "DB not exist to connect!!!"
			echo " "
                fi
		;;
	4) Drop_Database
		if test $? = "1" 
		then
			echo "DB not exist to drop!!!"
			echo " "
		fi
		;;
	5) exit
		;;
esac
done

}

echo "################################################################################"

read -p "Do You Want to Start (y or n) ? : " startchar
     if test $startchar = "y"
     then
	     echo "Please Wait..."
	     sleep 2
	     Init
	     Main_Menu
     else
	     exit
     fi
