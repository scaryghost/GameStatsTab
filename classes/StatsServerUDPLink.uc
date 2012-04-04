class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;

function PostBeginPlay() {
    udpPort= bindPort(6001, true);
    if (udpPort > 0) {
        Resolve("192.168.1.104");
    }
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= 6000;
    SendText(serverAddr, "Hello Server!");
}
