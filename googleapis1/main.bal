import ballerina/io;
import ballerina/http;
import ballerina/system;

final string CLIENT_ID = "880218952141-ijug2o3ofeichbhnr7bj63tajvbb4qdj.apps.googleusercontent.com";
final string CLIENT_SECRET = "RByTuKS74-xb7Jo8_AWs-LDV";
final string ACCESS_TOKEN =
"ya29.GluMBhcSmeiRp5HosTM4Ry7HhnahALnMQ_IbEtawvMkkMCTilXFlBymQzCtORyfOny6hzsC_KqV2DFovVNTeD__MGIB9bAY23M507sVs21ZVxESAspW4vRgwAHmT"
;
final string REFRESH_TOKEN = "1/_NNneGMC-eKTExgp1OboGZTeEWFMIozbxcgPUtNA2UE";

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

Client googleApiClient_ = new(googleApiConfig_);

public function main() {
    string text = "Sam is charged for a crime. John was let go by the commanding officer.";
    var sentimentResponse = googleApiClient_->getSentimentResponsePayload(text);
    if (sentimentResponse is json) {
        io:println(sentimentResponse.sentences[0].sentiment);
    } else {
        io:println("Error");
    }

    var documentSentiment = googleApiClient_->getDocumentSentiment(text);
    if (documentSentiment is json) {
        io:println(documentSentiment);
    } else {
        io:println("Error");
    }
}