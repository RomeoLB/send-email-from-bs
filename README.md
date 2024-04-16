# send-email-from-bs
Send an email from BS player using a web form and nodemailer running on node server

1. Download the repo to your PC/Mac

<img width="834" alt="image" src="https://github.com/RomeoLB/send-email-from-bs/assets/136584791/89877902-9359-45a5-be3d-442d1139765e">

2. Copy the content of the CopytoSDCard folder to a blank SD card

<img width="441" alt="image" src="https://github.com/RomeoLB/iframe-login/assets/136584791/446dcdbe-4447-472e-af11-1ac4f4376e6b">

3. Insert the SD card in the player and Power ON the layer
   
4. Navigate to the location where you have unzipped the repo and from the terminal enter 

``npm install``

The above step should install all the necessary node_modules that are required based on the content of the package.json file

5. I would suggest running your first test with Gmail account to send emails. Go to https://nodemailer.com/usage/using-gmail/ for further details on how to get a password for sending emails
6. Once you have obtained the password for your Gmail account change the user and pass values in the index.js file
   <img width="664" alt="image" src="https://github.com/RomeoLB/send-email-from-bs/assets/136584791/80590caf-f0c0-4be6-a9a7-800aa6bc913d">

From that point you can install other modules and/or change the code to suit your requirements. when you're ready to build your bundle.js file enter:

``npx webpack --config webpack.config.js``

This step should generate a new bundle.js file in the dist folder.

You are now ready to upload the bundle.js file to the pluginNodeApp folder using the player DWS or a suitable REST API mechanism.

Restart the autorun.brs or reboot the player to see your updated code running.


   
