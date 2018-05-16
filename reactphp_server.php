<?php

use Psr\Http\Message\ServerRequestInterface;
use React\Http\Middleware\LimitConcurrentRequestsMiddleware;
use React\Http\Middleware\RequestBodyBufferMiddleware;
use React\Http\Middleware\RequestBodyParserMiddleware;
use React\Http\Response;
use React\Http\StreamingServer;
use SAREhub\Commons\Misc\EnvironmentHelper;

require "vendor/autoload.php";

$loop = React\EventLoop\Factory::create();
$instanceId = EnvironmentHelper::getVar("INSTANCE_ID");
$limitConcurrentRequests = EnvironmentHelper::getVar("REACTPHP_LIMIT_CONCURRENT_REQUESTS", 20);

$server = new StreamingServer([
    new LimitConcurrentRequestsMiddleware($limitConcurrentRequests),
    new RequestBodyBufferMiddleware(2 * 1024 * 1024),
    new RequestBodyParserMiddleware(),
    function (ServerRequestInterface $request) use ($instanceId) {
        return new Response(200, ['Content-Type' => 'text/plain'], "Hello from instance: $instanceId\n");
    }
]);

$socket = new React\Socket\Server("0.0.0.0:9000", $loop, [
    "tcp_nodelay" => true,
    "backlog" => 20
]);

$loop->addSignal(SIGTERM, $func = function ($signal) use ($loop, &$func) {
    file_put_contents("php://stdout", "got SIGTERM stoping loop...");
    $loop->removeSignal(SIGINT, $func);
    $loop->stop();
});

$server->listen($socket);
$loop->run();