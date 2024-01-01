
const userRoutes = (app, userCon) => {
    app.post("/api/v1/users/checkIfEmailExists", userCon.reg_check_if_email_exists, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/reg", userCon.register, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/login", userCon.login, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/getLoggedUser", userCon.getLoggedUser, userCon.lastUserRequestMiddleware)
    app.post("/api/v1/users/contactUs", userCon.authenticateUser, userCon.contactUs, userCon.lastUserRequestMiddleware)
}
export default userRoutes


