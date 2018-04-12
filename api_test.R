library(aws.signature)
library(httr)
library(base64enc)

use_credentials() # Must have ~/.AWS/credential containing AWS key information

getAuth = function(headers, request) {
  
  sig = signature_v4_auth(datetime = headers$`X-Amz-Date`,
                          region = request[['region']],
                          service = request[['service']],
                          verb = request[['verb']],
                          action = request[['action']],
                          canonical_headers = headers,
                          request_body = request[['body']],
                          key = Sys.getenv("AWS_ACCESS_KEY_ID"),
                          secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"))
  sig$SignatureHeader
}

headers = list(`Content-Type` = "application/x-www-form-urlencoded",
               Host = "runtime.sagemaker.us-east-1.amazonaws.com",
               `X-Amz-Date` = format(Sys.time(), "%Y%m%dT%H%M%SZ"))

body = base64encode("uploads-cards-projects-1514880801528_AnINUVKdg.jpg")
request = list(region = "us-east-1",
               service = "sagemaker",
               verb = "POST",
               url = "https://runtime.sagemaker.us-east-1.amazonaws.com/endpoints/rimin-endpoint-production/invocations",
               host = "runtime.sagemaker.us-east-1.amazonaws.com",
               action = "/endpoints/rimin-endpoint-production/invocations",
               body = body)

response = POST(url = request[['url']],
                body = request[['body']],
                add_headers(.headers = c(`Content-Type` = headers[['Content-Type']],
                                         Host =  request[['host']],
                                         `X-Amz-Date` = headers[['X-Amz-Date']],
                                         Authorization = getAuth(headers, request))))

result = content(response)
unlist(result)
