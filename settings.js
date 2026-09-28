module.exports = {
    uiPort: process.env.PORT || 1880,

    adminAuth: {
        type: "credentials",
        users: [
            {
                username: process.env.NODERED_ADMIN_USERNAME,
                password: process.env.NODERED_ADMIN_PASSWORD_HASH,
                permissions: "*"
            }
        ]
    },

    flowFile: "flows.json",

    credentialSecret: process.env.NODE_RED_CREDENTIAL_SECRET
};
