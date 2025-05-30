const https = require('https'); 
const { GlueClient, StartCrawlerCommand, StartJobRunCommand } = require("@aws-sdk/client-glue");

exports.slack = async (webhook_url, action = "Filling Data")=>{
    const data = {
        text: `New file uploaded to S3!`,
        attachments: [
            {
                color: "#36a64f", 
                title: "S3 File Upload Notification",
                fields: [
                    { title: "Action", value: action, short: true },
                ],
                footer: "AWS S3 Notifier"
            }
        ]
    };
    const payload = JSON.stringify(data);

    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(payload),
        },
    };

    console.log("HOOOOOOOOOOOOOOOOOOOOOOOOOK")
    console.log(options)
    console.log(webhook_url)

    await new Promise((resolve, reject) => {
        const req = https.request(webhook_url, options, (res) => {
            let body = '';
            res.on('data', (chunk) => (body += chunk));
            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    console.log('Slack message sent successfully:', body);
                    resolve();
                } else {
                    console.error(`Failed to send Slack message. Status: ${res.statusCode}, Body: ${body}`);
                    reject(new Error(`Slack API error: ${res.statusCode} - ${body}`));
                }
            });
        });

        req.on('error', (e) => {
            console.error('Error sending Slack message:', e.message);
            reject(e);
        });
        req.write(payload); 
        req.end();
    });
}
exports.crawler = async (env) => {
    const region = env.REGION;
    const crawler = env.CRAWLER;

    await exports.slack(env.SLACK_WEBHOOK_URL, "Create Data Catalog")

    const glueClient = new GlueClient({ region: region });
    try {
        const command = new StartCrawlerCommand({ Name: crawler });
        await glueClient.send(command);
    } catch (error) {}
    


}

exports.data = async (env) => {
    const region = env.REGION;
    const job = env.JOB;

    exports.slack(env.SLACK_WEBHOOK_URL, "Fill Data")

    const glueClient = new GlueClient({ region: region });

    const jobCommand = new StartJobRunCommand({ JobName: job });

    await glueClient.send(jobCommand);
}

exports.handler = async (event) => {

    
    if(event.source == "aws.glue" ){ // start job [ glue completed ]
        console.log("################# JOB ####################")
        console.log(event)
        if(event.detail.state == "Succeeded"){
            await exports.data(process.env)
        }
    }else if(event.Records && event.Records.length > 0){ // start crawer [ file uploaded ]
        console.log("################# CRAWER ####################")
        console.log(event)
        await exports.crawler(process.env)
    }else{}

    return {
        statusCode: 200,
        body: JSON.stringify('Proccessing'),
    };
};

