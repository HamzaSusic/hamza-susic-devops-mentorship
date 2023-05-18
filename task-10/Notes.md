

The content of this md file consists of notes from: Architecture Deep Dive Part, AWS Lambda Part, CludWatchEvents and Event Bridge, Automated EC2 Control using lambda and events, Serverless Architecture, Simple Notification Service (SNS), Step Functions, API Gateway 101, Build a serverless app, Simple Queue Service (SQS), SQS Stadanard vs FIFO Queus, SQS Delay Queues




ARCHITECTURE DEEP DIVE


solution architecht - one solution specific architecture around given set of buisnes requirements

Event driven architecture

monolitic
upolad 
orccessing 
store and manage 

Its all one entity, if one commponent fails everything fails 
they scale together, all components same server, directly connected, samo codebase

Bill together allways running-always charges they allocete resources without using them

trrigered architecture
diff commponents still coupled together
benifit individual tiers can be scaled independetly either vertically or horizontaly, they are however still coupled, each tier has to be running something for the app to fucntion
 
load balancers located beeetween each tiers
internal load balancers 

it can be envolved by using que 
FIFO architecture 
que is decoupled commponents 
it uses syncrons or async communications
on the other side of que auto scaling group
based on que lenght 
jobs are proccesed by instances 
using a que architecture between 2 tiers decouples them
this allowes for high availability and scaling
no communication happens directly 
here it can scale from 0 to number of messages in que


microservice architecture 
collection of microservices, they do induvidual services very well
full app can have hundrets thousends of those services
producer produce messages
consumer consumes messages
both 
mic ser self suffficient app 

event driven architecture
collection of events producers which directly interact with users, bits of software to produce reaction to something

neither the producers or consumers dont constantly use resources, producers produce events, when consumer recieves event it takes action and than it stops 

event router
highly available central exchange point for events
event boss constant flow of information 
router delivers these to consumers



with event driven architecture no constant running
procures generate events when something happens 
events are delivered to consumers
mature event-driven arcgitecture only consumes resources while handeling events



AWS LAMBDA IN DEPTH

lambda is a function as a service (FaaS-short running and focussed code
lambda funciton a piece of code lambda runs
functions use a runtime 
functions are loaded and run in a runtime enviroment
the enviroment has a direct memory (indirect CPU) allocation
you are billled for duration that funciton runs
key part of serverless architectures


you define a lambda function-unit of configuration
code+ assoocieted wrappings and configuration
it is a deployment package that lambda executes
wheneever the lambda fucntion is invoked what acctualy happens is that deployment package is downloaded and executed within this runitme enviroment
if you see docker -antipattern for lambda
lambda supports docker images
you can use container images with lambda, specific images designed to run in lambda enviroments
every time lambda function is envoced, code loades its execudet and it terminates, next time new clean enviroment loads and after it finishes it is terminated
code running in lambda needs to run 100% of time
every time lambda function is envoced it is a new runtime enviroment
you need to define resources that lambda uses
128mb to 10240mb in in one MB steps 
you directly control the memory alloceted for lambda functions whereas vCPU is alloceted indirectly
512mb storage available as /tmp, up to 10240

lambda fucntion runs for up to 900s or 15 minits - function timeout

securty for lambda function is conntroleled
execcution roles iam roles assumed by lambda function which provides permission to interact with other aws services 

commen uses of lambda
core part of delivery of serverless application (s3, api gateway, lambda)
file processing (s3, s3 events, lambda)
database triggers(diynamodb, streams, lambda)
servereless CRON (EventBridge/CWEvents+Lambda)
realtime stream data processing (kinesis+lambda)


Lambda has 2 networking modes
 1. public-default
 2. vpc networking

public networking
by default lambda function are given public netwoeking, they can access public AWS services and the public intenet - best performance for lambda, lambda can run on shared hardware and networking, have no access to services on custum vpc 
 best performance because there is no custumer specific VPC networking 
 no access to vpc based services unless public IPs are provided and security contorols allow external access



lambda to run inside vpc
they obey same rules as anything in vpc, can freely accces all VPC services
VPC endppoints can provide access to public AWS services
NatGW and Internet Gateway are required for VPC Lambdas to access internet resources

if all functions used a collection of subnets but the same security groups then one network interface would be required per subnet if they used same subnet and same security group
then all of your lambda functions could use the single elastic network interface

treat lambda in vpc as any other resource in vpc

security of lambda functions


execution role-assumed by lambda-IAM roles attached to lambda functions which control the permissions the lambda function recieves

lambda resource policy controls what services and accounts can invoke lambda fucntions

LOGGING
lambda uses CloudWatch, CloudWatch Logs and X-Ray
logs from Lambda executions-CloudWatchLogs
Metrics-invocation success/failiure, retires, latency ... stored in CLoudwatch
Lambda can be integrated with X-Ray for distribudted tracing
CloudWatch Logs requires permisssions via Execution Role 

Invocation
synchronous invocation
asynchronous invocation
event source mappings

synchronous invocation
cli/api invoking lambda function, passing in data and waiting for the response 
lambda function responds with data or fials, any errors or retraies have to be handled within the client

asynchronous invocation
typically AWS servises invoke lambda functions, resources generates event and than it stops tracking it
the lambda fucntion needs to be idempotent reprocessing a result shoul have the same end state

if processing of event fails lambda will rety betwwen 0 and 2 times (configurable) Lambda handles the retry logic

events can be sent to dead letter queues after repeted failed proccessing

lambda supports destinations (SQS, SNS, Lambda and EventBridge) where successful or failed events can be sent

event source mapping
typically used on streams pr queues which dont support event generation to invoke lambda (Kinesis, DynamoDB streams, SQS)
permissions from the lambda execution role are used by the event source mapping to interact with the event source

LAMBDA VERSIONS

- version-v1,v2,v3...
- a version is the code + the configuration of the lambda function
- its immutable - it never changes once published and has its own Amazon Resource Name
- $Latest points at the latest version
- Aliases (DEV, STAGE, PROD) point at a version - can be changed

LAMBDA STARTUP TIMES
lambda code runs inside runtime enviroment 
first enviroment is created, then runtime and then deployment package is downloaded and 
installed - COLD START
An execution context is the enviroment a lambda function runs in. A cold start is a full 100ms creation and configuration including function code download

With a warm start, the same execution context is reused A new event is passed in but the execution creation can be skipped

a lmabda function can reuse an execcution context but has to assunme it cant If used infrequently contextd eill be removed Conccurent executions will use multiple (potenetially new) contexts

you can use tmp space to predownload things to improve on performance


CLAUDWATCH EVENTS AND EVENTBRIDGE

Deliver a near reltime stream of system events and these events descrebe changes in aws products and services.
EventBridge can also handle event of third party apps

Key Concpets 
imlement an architecture 
 - if x happnes or at y time do z
 - EventBrifge CloudWatch Events v2 (*)
 - Both operate on event bus
 - a default Event bus for the account
 - in CloudWatch Events this is the only bus (implicit)
 - EventBridge can have additional event busses
 - rules match incoming events ( or schedules)
 - route the events to 1+ Targets ..eg. Lambda

Default Event Bus - stream of events

whithin eventbrifge we have rules:
-pattern matching rules 
-scheduled rules

########### AUTOMATED EC2 CONTOROL USING LAMBDA AND EVENTS ###########


SERVERLESS ARCHITECTURE 

-serverless inst one single thing, it is more of a software architecture then hardware
-you manage few, if any servers - low overhand
-applications are a collection of small and specialised functions
-stateless and ephameral enviroments - duration billing
-event-driven...consumption only when being used
-FaaS is used where possible for compute funtionality
-managed services are used where posssible

The Serverless architecture is a evolution/combination of other popular architectures such as event-driven and microservices.

It aims to use 3rd party services where possible and FAAS products for any on-demand computing needs.

Using a serverless architecture means little to no base costs for an environment - and any cost incurred during operations scale in a way with matches the incoming load.

Serverless starts to feature more and more on the AWS exams - so its a critical architecture to understand.

Simple Notification Service 

-public aaws service - network connectivity with public endpoint
-coordinates the sending and delivery of messages
-messages are <=256KB payloads
-SNS Topics are the base entity of SNS - oermissions and configuration
-a Publisher sends messages to a TOPIC
-e.g. HTTP(s), Email(-Json),SQS,Lambda,SMS Messsages...
-SNS used accorss AWS for notifications-e.g. CloudWatch and CloudFormation

-deliveryyy Status - (HTTP,Lambda,SQS)
-delivery Retries - Realiable Delivery
-HA and Scalable (region)
-server side encryption (SSE)
-Cross-Account via TOPIC Policy




The Simple Notification Service or SNS is a highly available, secure, durable PUB SUB style notification system which is used within AWS products and services but can also form an essential part of serverless, event-driven and traditional application architectures.

Publishers send messages to TOPICS

Subscribers receive messages SENT to TOPICS.

SNS supports a wide variety of subscriber types including other AWS services such as LAMBDA and SQS.


STEP FUCNTIONS

Step functions is a product which lets you build long running serverless workflow based applications within AWS which integrate with many AWS services.

Addresses some of the Lambda limitations.

-lambda is a FaaS
-15-minute max exec time
-can be chained together
-gets messy at scale 
-runtime enviroments are stateless


State machines

-serverless workflow..start -> States -> end
-states are things which ocure
-maximum duration 1 year
-standdard workflow and express workflow 
-stadard is a defualt, express (IOT, streaming, mobile app backend) up to 5 min
-started via API Gateaway, IOT rules, EventBridge...
-Amazon States Language (ASL) - JSON Template
-IAM Role is used for permissions

States

-succeed and fail state
-wait 
-choice
-parallel
-map (list)
-TASK (single unit of work perfomed by state machine) - Lambda, Batch, DynamoDB, ECS, SQS...


API GATEWAY

-create and manage APIs
-Endpoint/entery-point for applications
-sits between applications and integration (services)
-hihgly available, scalable, handles authorisation, throttling, caching, CORS, transformations, OpenAPI spec, direct integration and much more.
-can connect to services/endpoints in AWS on-premises
-HTTP APIs, REST APIs and WebSocket APIs

API Gateway is a managed service from AWS which allows the creation of API Endpoints, Resources & Methods.

The API gateway integrates with other AWS services - and can even access some without the need for dedicated compute.

It serves as a core component of many serverless architectures using Lambda as event-driven and on-demand backing for methods.

It can also connect to legacy monolithic applications and act as a stable API endpoint during an evolution from a monolith to microservices and potentially through to serverless.


ENPOINT TYPES

-edge optimized
-routed to the nearest CloudFront POP
-regional - Clients in the same region
-Private - Endpoint accessible only whithin a VPC via interface endpoint


API Gateway Stages

APIs are deployed to stages each stage has one deployment

Stages can be enabled for canary deployments
If done, deployments are made to the canary not the stage

Stages enabled for canary deployments can be configured so a certain percentage of traffic is sent to the canary.
This can be adjusted over time - or the canary can be promoted to make it the new base stage.


API Gateway Errors

4xx - Client Error - invalid request on client side

5xx - Server Error - valid request, backend issue

400 - bad request - generic

403 - access denied - authorizer denises... WAF Filtered

429 - API Gateway can throttle - you exceeded that amount

502 - bad gateway exception - bad output returned by lambda

503 - service unavailable - backing endpoint offline? Major service issues

504 - integration failure/timeout - 29s limit


API CACHING

Cashing is configured per stage.
You define cachc in stage within API Gateway - it can be encrypted.




######### Building a Serverless App DEMO #####################


SQS

-public, fully managed, highly-available queues
-standard or FIFO
-messages up to 256kb in size - link to large data
-recieved messages are hidden (VIsibilityTimeout)
-...then either reapppear (retry) or are explicitly deleted
-Dead-Letter queues can be used for problem messages
-AGs can scale and Lambdas invoke based on a queue lenght


-Standard = at-leats-once, FIFO = exactly-once

-FIFO (performance) 3,000 messages per second with batching, or up to 300 messagesper second without

-billed based on requests

-1 request = 1-10 messages up to 64KB total

-Short (immediate) vs Long (waitTimeSeconds) Polling

-encryption (server side) at rest (KMS) and in transit

-Queue policy...


SQS STANDARD VS FIFO

-Standard can scale as required, near unlimited TPS, best effort ordering, no rigid perservation of message order, at least once delivery, there could on occasion be more than one copy of a message, decoupling 
-FIFO 300 TPS - 3000 TPS, message order is strictly perserved, first in first out, exactly one processing, duplicates are removed


SQS DELAY QUEUES 

Delay queues provide an initial period of invisibility for messages. Predefine periods can ensure that processing of messages doesn't begin until this period has expired

We confiigure a value called delay second on the que. messages startup in invisible state for that time, default is 0, maximum is 15 min.

Message timers allow a per-message invisibility to be set, overriding any queue setting.

Not supported by FIFO queues.











 







 










