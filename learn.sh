#!/bin/bash


# If words.txt hasn't been created, create it and quit
if [[ ! -f 'words.txt' ]]; then
    echo "Your list of words to learn does not exist!"
    echo "The file 'words.txt' has been created."
    echo "Please add the words you wish to learn in this file."
    touch words.txt
    exit 1
fi

# If the words file is empty, error
word_count=$(cat words.txt | wc -l)
if [[ "$word_count" -eq "0" ]]; then
    echo "You haven't added any words to your words.txt file yet!"
    echo "Add some words you want to learn then run this again."
    exit 1
fi

# Pre start warning
clear
echo "Practice is about to begin!"
echo "Press enter key to continue."
read

cat words.txt | tr '[:upper:]' '[:lower:]' | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' > /tmp/words.txt

# Initilise arrays
correct=()
incorrect=()

for word  in $(cat /tmp/words.txt); do
    while [ 1 ]; do
        clear
        echo "[S]olve  [R]epeat  E[x]it"
        say $word
        read -s -n 1 option
        case "$option" in
            r)
                continue
                ;;
            s)
                echo -n "Solve: "
                read answer
                if [[ "$answer" == "$word" ]]; then
                    say "Well done!" &
                    echo "Correct! Press enter to continue."
                    correct+=($word)
                    read
                    break
                else
                    say "Incorrect." &
                    echo "Uh oh you didn't get it right this time :("
                    echo "Press enter to continue"
                    incorrect+=($word)
                    read
                    break
                fi
                ;;
            x)
                echo -n "Are you sure you want to quit? Y/n"
                read -s -n 1 quit
                if [[ "$quit" == "Y" ]]; then
                    exit 0
                fi
                ;;
        esac
    done
done

# Completed
clear
echo "All done! Come back next time"
total_words=$(cat /tmp/words.txt | wc -l | sed 's/ //g')
echo -e "You spelt ${#correct[@]}/$total_words words correctly."

incorrect_total=${#incorrect[@]}
if [[ "$incorrect_total" -ne "0" ]];then
    echo "Incorrect: $incorrect_total"
    printf ' - %s\n' "${incorrect[@]}"
fi
exit 0
