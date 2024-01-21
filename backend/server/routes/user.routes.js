
const userRoutes = (app, userCon) => {
    app.post("/api/v1/users/checkIfEmailExists", userCon.checkIfEmailExists, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/reg", userCon.register, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/login", userCon.login, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/getLoggedUser", userCon.getLoggedUser, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/contactUs", userCon.authenticateUser, userCon.contactUs, userCon.lastUserRequestMiddleware)
    // app.post("/api/v1/users/editProfile", userCon.authenticateUser, userCon.editProfile, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/verifyEmail", userCon.verifyEmail, userCon.lastUserRequestMiddleware)

    // app.post("/api/v1/users/getCodeToEmail", userCon.authenticateUser, userCon.getCodeToEmail, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/getCodeToEmail", userCon.getCodeToEmail, userCon.lastUserRequestMiddleware)


    app.post("/api/v1/users/changePassword", userCon.authenticateUser, userCon.changePassword, userCon.lastUserRequestMiddleware) 
    app.post("/api/v1/users/deleteAccount", userCon.authenticateUser, userCon.deleteAccount, userCon.lastUserRequestMiddleware)
}

export default userRoutes


