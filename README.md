# A swift IOS app that lets users generate images using the chatgpt API

> This is my portfolio app for Swift

This app allows its users to generate up to 15 images. Users can register, and during registration, their email addresses need to be authenticated. They can also perform actions such as logging in, resetting their passwords via email with multi-factor authentication (MFA), generating images, deleting accounts, and more. The images generated are saved in a database, which users can access at any time. Additionally, all data transit within the app is secured by TLS.

#### Languages used:

Swift (frontend) | Javascript (backend) with Mongoose, MongoDB, ExpressJs

For swift Im using MVVM architecture, and coreData to store objects, I tried the new SwiftData but that seems only appropriate for an array of objects and doesn't work well for MVVM.

#### Production Tools used:

AWS's [S3-buckets | EC2 | Route53 | SES], MongoDB, GoDaddy to register domain


## App 
<!-- TODO add link to Appstore when finished -->
<center><a href="https://www.genta-ios.app" target="_blank">Website</a>&emsp;&emsp;&emsp;&emsp;<a href="" target="_blank">App on AppStore</a></center>

<table>
    <thead>
        <tr>
            <th><h5 style="text-align: center;">Register</h5></th>
            <th><h5 style="text-align: center;">Generate image</h5></th>
            <th><h5 style="text-align: center;">All generated images</h5></th>
            <th><h5 style="text-align: center;">Contact Us</h5></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><img src="app_design/app-show-images/for-app-store/gif/register.gif" alt="register" width="200"></td>
            <td><img src="app_design/app-show-images/for-app-store/gif/generate-image.gif" alt="Generate image" width="200"></td>
            <td><img src="app_design/app-show-images/for-app-store/gif/all-generated-iamges.gif" alt="all-generated-images" width="200"></td>
            <td><img src="app_design/app-show-images/for-app-store/gif/Contact-us.gif" alt="contact us" width="200"></td>
        </tr>
    </tbody>
</table>
 

Issues with app:

1. I did not take great care for storing large images in coreData, this might be an issue if the user is storing many images, the user can only store 15 at most images for this app.

App data:

```json
{
    "user": {
        "email": "",
        "password": "",
        "first_name": "",
        "last_name": "",
        "age": "",
        "generated_imgs": [
            {
                "img_id": "UUID, #key used to get presigned url for user to be able to access the image",
                "prompt": " either gpt revised use REVISED:%j&# | or its just string"
            }
        ]
    },
    "app_run_time": {
        "easy_shutdown": "When the client boots up app, checking if the backend can be reached before doing anything. This way if in the future I can easily shut everything down",
        "Sessions": "JWT tokens and presigned s3 buckets lasts 3 hours"
    },
    "products-used-for-deployment": {
        "Ec2": "backend server is hosted on Amazon EC2",
        "Godaddy": {
            "purpose": "the domain is registered with Godaddy",
            "domain": "genta-ios.app"
        }
    }
}
```