import ballerina/http;
import ballerina/io;


public type Client client object {
    public http:Client googleApiClient;

    public function __init(GoogleAPIConfig googleApiConfig) {
        self.init(googleApiConfig);
        self.googleApiClient = new(BASE_URL, config = googleApiConfig.clientConfig);
    }

    # Initialize GoogleAPI endpoint.
    #
    # + googleApiConfig - GoogleAPI Configuration
    public function init(GoogleAPIConfig googleApiConfig);

    # Get the json payload of the response after calling the Google's Sentiment Analyzer
    #
    # + text - the text to be analyzed
    # + return - If successful, returns json payload of the response. Else returns error.
    public remote function getSentimentResponsePayload(string text) returns json|error;

    # Get the document sentiment portion of the payload (of the sentiment response)
    #
    # + text - the text to be analyzed
    # + return - If successful, returns json payload of the responseponse. Else returns error.
    public remote function getDocumentSentiment(string text) returns DocumentSentiment|error;
};

remote function Client.getSentimentResponsePayload(string text) returns json|error {
    json jsonBody = {
        document: {
            "type": PLAIN_TEXT,
            "content": text
        },
        encodingType: "UTF8"
    };

    string body = jsonBody.toString();

    http:Request request = new;
    request.setHeader(CONTENT_TYPE, APPLICATION_JSON);
    request.setPayload(body);

    http:Response|error httpResponse = self.googleApiClient->post(ANALYZE_SENTIMENT_URL, request);

    if (httpResponse is http:Response) {
        json jsonPayload = check httpResponse.getJsonPayload();
        return jsonPayload;
    } else {
        return httpResponse;
    }
}

remote function Client.getDocumentSentiment(string text) returns DocumentSentiment|error {
    var sentimentResponsePayload = self->getSentimentResponsePayload(text);
    if (sentimentResponsePayload is json) {
        DocumentSentiment documentSentiment = check DocumentSentiment.convert(sentimentResponsePayload.documentSentiment);
        return documentSentiment;
    } else {
        return sentimentResponsePayload;
    }
}

function Client.init(GoogleAPIConfig googleApiConfig) {
    http:AuthConfig? authConfig = googleApiConfig.clientConfig.auth;
    if (authConfig is http:AuthConfig) {
        authConfig.refreshUrl = REFRESH_TOKEN_EP;
        authConfig.scheme = http:OAUTH2;
    }
}

# Object for GoogleAPI Configuration
#
# + clientConfig - The http client endpoint
public type GoogleAPIConfig record {
    http:ClientEndpointConfig clientConfig;
};