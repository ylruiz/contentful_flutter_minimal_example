# using_contentful_flutter

A Flutter project that demonstrates how to integrate Contentful's content management capabilities into a Flutter app. This project leverages the [`contentful_flutter`](https://pub.dev/packages/contentful_flutter) package, which simplifies working with the Contentful Content Delivery API by handling API requests, authentication, and data retrieval in a Flutter-friendly manner.

## Overview

[Contentful](https://www.contentful.com) is a headless content management system (CMS) that allows you and your team to manage and deliver structured content for apps, websites, and other digital experiences. In this project, `contentful_flutter` is used to access Contentful data and display it within the app, providing a simple example of integrating Contentful with Flutter.

## Getting Started

This guide will help you set up, configure, and run the app on your local development environment.

### Prerequisites

Ensure you have the following installed on your system:
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Contentful account](https://www.contentful.com/) with API credentials

### Setup

1. **Clone the Repository:**

        git clone https://github.com/ylruiz/contentful_flutter_minimal_example.git
        cd contentful_flutter_minimal_example

2. **Environment Configuration**

    a) Create a .env file in the root directory of the project.

    b) Add your Contentful API credentials in the .env file as follows:
        
        SPACE_ID=your_space_id
        API_ACCESS_TOKEN=your_access_token

3. **Install the dependencies**

        flutter pub get

4. **Run Build Runner**

       flutter pub run build_runner build --delete-conflicting-outputs 


    

