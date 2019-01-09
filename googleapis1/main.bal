import ballerina/io;


final string CLIENT_ID = "";
final string CLIENT_SECRET = "";
final string ACCESS_TOKEN = "";
final string REFRESH_TOKEN = "";

GoogleAPIConfig googleApiConfig_ = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: ACCESS_TOKEN,
            clientId: CLIENT_ID,
            clientSecret: CLIENT_SECRET,
            refreshToken: REFRESH_TOKEN
        }
    }
};


public function main() {
    io:println("Hello World");
}