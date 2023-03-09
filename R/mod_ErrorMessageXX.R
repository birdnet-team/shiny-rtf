require("mailR")

PASS <- as.character("BirdNETMonitoring2023")

send.mail(from="birdnet.monitoring@gmail.com",
          to=c("birdnet.monitoring@gmail.com"),
          subject = "Unit went down",
          body="Unit went down, please check connection",
          smtp=list(host.name="smtp.gmail.com", port=465,user.name="birdnet.monitoring",password=PASS, ssl=TRUE),
          authenticate = TRUE,
          send=TRUE)
