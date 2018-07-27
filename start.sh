#!/bin/bash
# dpcrk v0.1
# Made by Dr. Waldijk
# A script to show and suggest possible PIN combinations.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
DPCRKNAM="dpcrk"
DPCRKVER="0.1"
# Functions -------------------------------------------------------------------------
dpcrk_head () {
    clear
    echo "$DPCRKNAM v$DPCRKVER"
    echo ""
}
pincrk () {
    if [[ "$DPCRKRNG" -eq "10" ]]; then
        DPCRKPIN="0"
        DPCRKCNT="0"
    elif [[ "$DPCRKRNG" -le "9" ]]; then
        DPCRKPIN="1"
        DPCRKCNT="0"
    fi
    until [[ "$DPCRKCNT" = "$DPCRKCMB" ]]; do
        if [[ "$DPCRKPIN" -le "9" ]] && [[ "$DPCRKCOM" -eq "2" ]]; then
            if [[ "$DPCRKRNG" -eq "10" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{1})/0\1/')
            elif [[ "$DPCRKRNG" -le "9" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{1})/1\1/')
            fi
        elif [[ "$DPCRKPIN" -le "9" ]] && [[ "$DPCRKCOM" -eq "3" ]]; then
            if [[ "$DPCRKRNG" -eq "10" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{1})/00\1/')
            elif [[ "$DPCRKRNG" -le "9" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{1})/11\1/')
            fi
        elif [[ "$DPCRKPIN" -le "99" ]] && [[ "$DPCRKCOM" -eq "3" ]]; then
            if [[ "$DPCRKRNG" -eq "10" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{2})/0\1/')
            elif [[ "$DPCRKRNG" -le "9" ]]; then
                DPCRKPIN=$(echo "$DPCRKPIN" | sed -r 's/([0-9]{2})/1\1/')
            fi
        else
            if [[ "$DPCRKRNG" -le "9" ]] && [[ "$DPCRKCOM" -ge "2" ]]; then
                case $DPCRKPIN in
                    [1-9]0)
                        DPCRKPIN=$(expr $DPCRKPIN + 1)
                    ;;
                    [1-9][0-9]0)
                        DPCRKPIN=$(expr $DPCRKPIN + 1)
                    ;;
                    [1-9]0[1-9])
                        DPCRKPIN=$(expr $DPCRKPIN + 10)
                    ;;
                esac
            fi
        fi
        echo "$DPCRKPIN"
        DPCRKPIN=$(expr $DPCRKPIN + 1)
        DPCRKCNT=$(expr $DPCRKCNT + 1)
    done
}
# -----------------------------------------------------------------------------------
dpcrk_head
echo "Number range between 1-9 (1-9) or 10 (0-9):"
read -p "> " DPCRKRNG
echo ""
echo "How many digits do the PIN have:"
read -p "> " DPCRKCOM
DPCRKCMB=$(echo "$DPCRKRNG^$DPCRKCOM" | bc)
dpcrk_head
echo "This $DPCRKCOM-digit PIN has $DPCRKCMB combinations."
echo ""
echo "Do you want to do diplay all combinations?"
read -p "(y/n)" -s -n1 DPCRKKEY
DPCRKKEY=$(echo "$DPCRKKEY" | tr [a-z] [A-Z])
if [[ "$DPCRKKEY" = "y" ]] || [[ "$DPCRKKEY" = "Y" ]]; then
    dpcrk_head
    echo "Loading..."
    DPCRKRES=$(pincrk)
    dpcrk_head
    echo "Do know any of the digits?"
    read -p "(y/n)" -s -n1 DPCRKKEY
    DPCRKKEY=$(echo "$DPCRKKEY" | tr [a-z] [A-Z])
    if [[ "$DPCRKKEY" = "y" ]] || [[ "$DPCRKKEY" = "Y" ]]; then
        dpcrk_head
        echo "How many digits do you know?"
        read -p "> " DPCRKDIG
        DPCRKCNT="0"
        until [[ "$DPCRKCNT" = "$DPCRKDIG" ]]; do
            DPCRKCNT=$(expr $DPCRKCNT + 1)
            echo "What is the digit?"
            read -p "> " DPCRKKEY
            DPCRKPOS[$DPCRKCNT]=$(echo "$DPCRKKEY")
        done
        DPCRKCNT="0"
        until [[ "$DPCRKCNT" = "$DPCRKDIG" ]]; do
            DPCRKCNT=$(expr $DPCRKCNT + 1)
            DPCRKRES=$(echo "$DPCRKRES" | grep "${DPCRKPOS[$DPCRKCNT]}")
        done
    fi
    dpcrk_head
    echo "Do know the position of the digits?"
    read -p "(y/n)" -s -n1 DPCRKKEY
    DPCRKKEY=$(echo "$DPCRKKEY" | tr [a-z] [A-Z])
    if [[ "$DPCRKKEY" = "y" ]] || [[ "$DPCRKKEY" = "Y" ]]; then
        echo ""
        echo "What are the digits?"
        echo "[you can use regex]"
        read -p "> " DPCRKDIG
        DPCRKRES=$(echo "$DPCRKRES" | grep -E "^$DPCRKDIG")
    fi
    dpcrk_head
    echo "Possible combinations are:"
    echo "$DPCRKRES"
fi
