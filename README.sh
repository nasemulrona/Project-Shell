#!/bin/bash

# File to store user information
user_file="users.txt"
order_log_file="order_log.txt"

# Restaurant details
restaurant_name="Rona Bhai Fast Food Restaurant"
email="nasemulrona0661@gmail.com"
contact="01758101881"

# Function to hash passwords
hash_password() {
    echo "$1" | shasum -a 256 | awk '{print $1}'
}

# Function for Admin Sign Up
admin_signup() {
    echo "Admin Sign Up"
    read -p "Enter username: " username
    read -sp "Enter password: " password
    echo
    hashed_password=$(hash_password "$password")
    echo "admin:$username:$hashed_password" >> "$user_file"
    echo "Admin signed up successfully!"
}

# Function for Admin Log In
admin_login() {
    echo "Admin Log In"
    read -p "Enter username: " username
    read -sp "Enter password: " password
    echo
    hashed_password=$(hash_password "$password")
    
    if grep -q "admin:$username:$hashed_password" "$user_file"; then
        echo "Admin logged in successfully!"
        admin_menu
    else
        echo "Invalid credentials. Please try again."
    fi
}

# Function for Customer Sign Up
customer_signup() {
    echo "Customer Sign Up"
    read -p "Enter username: " username
    read -sp "Enter password: " password
    echo
    hashed_password=$(hash_password "$password")
    echo "customer:$username:$hashed_password" >> "$user_file"
    echo "Customer signed up successfully!"
}

# Function for Customer Log In
customer_login() {
    echo "Customer Log In"
    read -p "Enter username: " username
    read -sp "Enter password: " password
    echo
    hashed_password=$(hash_password "$password")
    if grep -q "customer:$username:$hashed_password" "$user_file"; then
        echo "Customer logged in successfully!"
        customer_menu
    else
        echo "Invalid credentials. Please try again."
    fi
}

# Function to display the menu
display_menu() {
    echo "🍽️ Menu Card 🍽️"
    echo "1. 🍕 Pizza - Tk. 200"
    echo "2. 🍔 Burger - Tk. 150"
    echo "3. 🥪 Subway - Tk. 180"
    echo "4. 🥟 Shingara - Tk. 20"
    echo "5. 🍳 Bhapa Ilish - Tk. 250"
    echo "6. 🍛 Kacchi Biryani - Tk. 200"
    echo "7. 🍲 Chicken Bhuna - Tk. 180"
    echo "8. 🥪 Chicken Sandwich - Tk. 100"
    echo "9. 🗑️ Delete an item"
    echo "10. 🧾 View Bill"
    echo "0. 📋 Place Order and Exit"
    echo ""
}

# Declare a plain array 
selected_items=()

# Function to process the user's choice
process_choice() {
    case $1 in
        1)
            echo "You selected Pizza - Tk. 200"
            selected_items+=("Pizza 200")
            ;;
        2)
            echo "You selected Burger - Tk. 150"
            selected_items+=("Burger 150")
            ;;
        3)
            echo "You selected Subway - Tk. 180"
            selected_items+=("Subway 180")
            ;;
        4)
            echo "You selected Shingara - Tk. 20"
            selected_items+=("Shingara 20")
            ;;
        5)
            echo "You selected Bhapa Ilish - Tk. 250"
            selected_items+=("Bhapa_Ilish 250")
            ;;
        6)
            echo "You selected Kacchi Biryani - Tk. 200"
            selected_items+=("Kacchi_Biryani 200")
            ;;
        7)
            echo "You selected Chicken Bhuna - Tk. 180"
            selected_items+=("Chicken_Bhuna 180")
            ;;
        8)
            echo "You selected Chicken Sandwich - Tk. 100"
            selected_items+=("Chicken_Sandwich 100")
            ;;
        9)
            delete_item
            ;;
        10)
            view_bill
            ;;
        0)
            echo "Placing your order..."
            view_bill
            log_order
            echo "Thank you for ordering. Enjoy your meal!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Function to delete a selected item
delete_item() {
    echo "Selected items to delete:"
    for item in "${selected_items[@]}"; do
        echo "$item"
    done

    read -p "Enter the name of the item to delete: " item_to_delete

    new_selected_items=()
    for item in "${selected_items[@]}"; do
        if [[ $item != $item_to_delete* ]]; then
            new_selected_items+=("$item")
        fi
    done

    selected_items=("${new_selected_items[@]}")
    echo "$item_to_delete has been deleted."
}

# Function to view the bill
view_bill() {
    total=0
    echo ""
    echo "*****************************"
    echo "  $restaurant_name"
    echo "  Contact: $contact"
    echo "  Email: $email"
    echo "*****************************"
    echo ""
    echo "Your Bill:"
    echo "---------------------------------"
    for item in "${selected_items[@]}"; do
        item_name=$(echo "$item" | awk '{print $1}')
        item_price=$(echo "$item" | awk '{print $2}')
        item_display=$(echo "$item_name" | tr '_' ' ')
        echo "$item_display - Tk. $item_price"
        total=$((total + item_price))
    done
    echo "---------------------------------"
    echo "Total Price: Tk. $total"
    echo "---------------------------------"
}

# Function to log the order
log_order() {
    total=0
    order_details="Order Details:\n"
    for item in "${selected_items[@]}"; do
        item_name=$(echo "$item" | awk '{print $1}')
        item_price=$(echo "$item" | awk '{print $2}')
        item_display=$(echo "$item_name" | tr '_' ' ')
        order_details+="$item_display - Tk. $item_price\n"
        total=$((total + item_price))
    done
    order_details+="Total Price: Tk. $total\n"
    echo -e "$order_details" >> "$order_log_file"
}

# Function for Admin Menu
admin_menu() {
    while true; do
        display_menu
        read -p "Enter the item numbers to select: " -a choices
        echo ""

        # Process each selected item
        for item in "${choices[@]}"; do
            process_choice "$item"
        done

        echo "You have selected the following items:"

        # Display the selected items and their prices
        for item in "${selected_items[@]}"; do
            item_name=$(echo "$item" | awk '{print $1}')
            item_price=$(echo "$item" | awk '{print $2}')
            item_display=$(echo "$item_name" | tr '_' ' ')
            echo "$item_display - Tk. $item_price"
        done

        echo ""
    done
}

# Function for Customer Menu
customer_menu() {
    while true; do
        display_menu
        read -p "Enter the item numbers to select: " -a choices
        echo ""

        # Process each selected item
        for item in "${choices[@]}"; do
            process_choice "$item"
        done

        echo "You have selected the following items:"

        # Display the selected items and their prices
        for item in "${selected_items[@]}"; do
            item_name=$(echo "$item" | awk '{print $1}')
            item_price=$(echo "$item" | awk '{print $2}')
            item_display=$(echo "$item_name" | tr '_' ' ')
            echo "$item_display - Tk. $item_price"
        done

        echo ""
    done
}

# Main menu
while true; do
    echo "1. Admin Sign Up"
    echo "2. Admin Log In"
    echo "3. Customer Sign Up"
    echo "4. Customer Log In"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            admin_signup
            ;;
        2)
            admin_login
            ;;
        3)
            customer_signup
            ;;
        4)
            customer_login
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
