# DSP-Desk

## 📱 Project Setup Guide

Thank you for reviewing this project! This guide will help you set up an Android emulator to easily test the app on your machine. By following these steps, you'll be able to clone the repository, run the app, and see everything working in an Android emulator.

### 🛠️ Prerequisites

Before we begin, please ensure you have the following installed on your computer:

**Git**: To clone the repository.

**Flutter** Flutter is used to develop this application. Please follow Flutter's official installation guide to set it up if you haven't already.

**Android Studio**: We'll use Android Studio to create an Android emulator. You can download it from here.

### 🚀 Step-by-Step Setup Instructions

1. Clone the Repository
2. Open the Project
3. Install Dependencies
4. Set Up Android Emulator
5. Run the App
6. Navigating the App


#### Clone the Repository
First, clone the repository to your computer. Open a terminal or command prompt and type the following command:

`git clone <repository_url>`

Replace <repository_url> with the link to the repository provided to you.

#### Open the Project

Navigate to the project folder:

`cd <project-folder-name>
`

Replace <project-folder-name> with the name of the cloned project folder.

####  Install Dependencies

To install all required dependencies, run:

`flutter pub get
`

This will fetch all the necessary Flutter packages to run the application.

#### Set Up Android Emulator

**Open Android Studio**

  Launch Android Studio and click on Tools in the top menu.

**AVD Manager**

  Select AVD Manager (Android Virtual Device Manager) from the dropdown.

**Create Virtual Device**

  Click on Create Virtual Device.

Choose a device, such as Pixel 5, and click Next.

**Select a System Image** 
You may need to download one if it's not already available. Preferably, choose an image with API Level 30 or higher.

Click Next and then Finish.

**Start Emulator**
Once the virtual device is created, click the green Play button next to it to start the emulator.

**Run the App
**
Now that the emulator is running, you can use Flutter to run the app:

`flutter run
`

This command will build and install the app on the running emulator.

**Note**: Make sure the emulator is running before you execute flutter run.

#### Navigating the App

Once the app is running on the emulator, you will be able to interact with it and test all its features.

### 🔧 Troubleshooting

**Emulator Not Detected**: If flutter run is unable to detect the emulator, make sure that:

The emulator is properly running and visible in Android Studio.

Your system environment variables are properly configured, especially ANDROID_HOME.

**Dependencies Issue**: If there are any missing dependencies, try running:

`flutter doctor
`

This command will show if there are any unresolved issues.

### 📌 Closing Notes

You should now be ready to test the app in an Android emulator! If you encounter any issues during the setup or while running the app, please feel free to reach out for help.

Happy Testing! 🎉
