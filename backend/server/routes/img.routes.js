const imgRoutes = (app, api, userController) => {
    app.post("/api/v1/imgs/generate", userController.authenticateUser, api.generateImg, userController.addImgToUser)
}

export default imgRoutes