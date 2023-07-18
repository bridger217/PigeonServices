// import fetch from 'node-fetch';

export async function sendNewMemoryNotification() {
    const reqBody: any = {
        app_id: "95ef9d8f-ac09-49ba-be15-fd6252f09853",
        include_external_user_ids: ["natalie"],
        channel_for_external_user_ids: 'push',
        data: {
            newMemory: true
        },
        headings: {
            en: "Pigeon Services!"
        },
        contents: {
            en: "You have received a new memory."
        },
        ios_badgeType: "Increase",
        ios_badgeCount: 1
    };
    const url = 'https://onesignal.com/api/v1/notifications';
    const options = {
        method: 'POST',
        headers: {
            accept: 'application/json',
            Authorization: 'Basic NjZiZDhhNjItOGRmNS00MjQzLWI3Y2EtMDBlOGFlNWY4NjZl',
            "Content-Type": "application/json"
        },
        body: JSON.stringify(reqBody)
    };

    const resp = await fetch(url, options);
    if (resp.status >= 400) {
        const data = await resp.json();
        console.error(`Push notification error: ${(resp.status)}, ${JSON.stringify(data)}. Params: ${JSON.stringify(options)}`);
    } else {
        console.log("Push notification sent.");
    }
}