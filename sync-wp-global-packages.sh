#!/bin/bash

# Get the "Tested up to" version from the plugin's readme.txt file.
readme_file="$plugindir/readme.txt"
tested_up_to=$(grep "Tested up to: " "$readme_file" | sed 's/Tested up to: //')

# If $tested_up_to has a value, then try syncing the versions of the global packages.
if [ ! -z "$tested_up_to" ]; then

    # Download the package.json file from the "Tested up to" version of WordPress.
    curl -s https://raw.githubusercontent.com/WordPress/wordpress-develop/$tested_up_to/package.json -o wp-$tested_up_to-package.json

    # Check if the package.json file was downloaded successfully.
    if [ ! -f wp-$tested_up_to-package.json ]; then
        echo "Failed to download the package.json file for WordPress $tested_up_to."
    else
        echo "Syncing global packages in package.json with WordPress $tested_up_to versions..."
        # Read the package.json file line by line
        while IFS= read -r line; do
        # Check if the line contains a dependency that starts with "@wordpress".
        if echo "$line" | grep -q '"@wordpress'; then
            # Extract the key and value using awk
            unescaped_key=$(echo "$line" | awk -F'"' '{print $2}')
            value=$(echo "$line" | awk -F'"' '{print $4}')

            # Escape the forward slashes in the key
            key=$(echo "$unescaped_key" | sed 's/\//\\\//g')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"$key\": \".*\"/\"$key\": \"$value\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                echo "Setting $unescaped_key to match WP $tested_up_to version: $value";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
        # Check if the line is for react.
        if echo "$line" | grep -q '"react":'; then
            # Extract the version of react
            react_version=$(echo "$line" | awk -F'"' '{print $4}')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"react\": \".*\"/\"react\": \"$react_version\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                 echo "Setting react to match WP $tested_up_to version: $react_version";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
        # Check if the line is for react-dom.
        if echo "$line" | grep -q '"react-dom":'; then
            # Extract the version of react-dom
            react_dom_version=$(echo "$line" | awk -F'"' '{print $4}')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"react-dom\": \".*\"/\"react-dom\": \"$react_dom_version\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                 echo "Setting react-dom to match WP $tested_up_to version: $react_dom_version";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
        # Check if the line is for jquery
        if echo "$line" | grep -q '"jquery":'; then
            # Extract the version of jquery
            jquery_version=$(echo "$line" | awk -F'"' '{print $4}')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"jquery\": \".*\"/\"jquery\": \"$jquery_version\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                 echo "Setting jquery to match WP $tested_up_to version: $jquery_version";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
        # Check if the line is for lodash
        if echo "$line" | grep -q '"lodash":'; then
            # Extract the version of lodash
            lodash_version=$(echo "$line" | awk -F'"' '{print $4}')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"lodash\": \".*\"/\"lodash\": \"$lodash_version\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                 echo "Setting lodash to match WP $tested_up_to version: $lodash_version";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
        # Check if the line is for moment
        if echo "$line" | grep -q '"moment":'; then
            # Extract the version of moment
            moment_version=$(echo "$line" | awk -F'"' '{print $4}')

            # Replace the value in the current package.json file
            sed -i.bak "s/\"moment\": \".*\"/\"moment\": \"$moment_version\"/g" package.json

            # Check if sed made changes by comparing the modified file with the backup
            if [ "$(cat "package.json.bak")" != "$(cat "package.json")" ]; then
                # Print the action taken.
                 echo "Setting moment to match WP $tested_up_to version: $moment_version";
            fi

            # Remove the backup file created by sed
            rm package.json.bak
        fi
            
        done < wp-$tested_up_to-package.json

        # Remove the downloaded package.json file.
        rm wp-$tested_up_to-package.json
    fi

fi

