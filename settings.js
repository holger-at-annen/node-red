module.exports = {

    /*
     * Node-RED editor port.
     *
     * Coolify's proxy will route your domain to port 1880.
     */
    uiPort: process.env.PORT || 1880,

    functionGlobalContext: {
        crypto: require("crypto")
    },

    /*
     * Node-RED editor authentication.
     *
     * Username:
     *   Supplied by Coolify.
     *
     * Password:
     *   Supplied by Coolify at startup, converted to bcrypt
     *   by docker-entrypoint.sh, then supplied here as a hash.
     */
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


    /*
     * Keep the credential encryption key stable.
     *
     * This is supplied by Coolify and must NOT be changed
     * after Node-RED has stored encrypted credentials.
     */
    credentialSecret: process.env.NODE_RED_CREDENTIAL_SECRET,


    /*
     * Node-RED's normal flow file.
     *
     * Because /data is the persistent user directory,
     * this file survives container recreation.
     */
    flowFile: "flows.json",


    /*
     * Standard Node-RED console logging.
     */
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    }
};
