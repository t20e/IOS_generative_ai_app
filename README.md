# An IOS app that lets users generate their own images using the chatgpt API

> This is app is my portfolio for swifttUI

#### Languages used: Swift (frontend) | Javascript (backend) Mongoose ExpressJs nodeJs
Im using MVVM architecture for swift, and coreData to store objects, I tried the new SwiftData but that seems only appropriate for an array of objects and doesnt work well for MVVM
#### Tools used: AWS's S3-buckets and EC2, MongoDB


This app allows its users to generate 15 free images every week and after that they can pay per image with a third party provider. Users can register which will need to be authenticated their emails, login reset password by email MFA, generate images, delete account, and more. The images generated are saved on database, which users can access anytime.
