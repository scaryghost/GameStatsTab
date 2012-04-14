class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;

function PostBeginPlay() {
    udpPort= bindPort(class'GameStatsTabMut'.default.serverPort+1, true);
    if (udpPort > 0) {
        Resolve(class'GameStatsTabMut'.default.serverIp);
    }
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= class'GameStatsTabMut'.default.serverPort;
    SendText(serverAddr, "Hello World!");
}
