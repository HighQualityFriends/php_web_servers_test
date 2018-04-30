<?php

use Psr\Http\Message\ServerRequestInterface;
use React\Http\Middleware\LimitConcurrentRequestsMiddleware;
use React\Http\Middleware\RequestBodyBufferMiddleware;
use React\Http\Middleware\RequestBodyParserMiddleware;
use React\Http\Response;
use React\Http\Server;
use React\Http\StreamingServer;

require "vendor/autoload.php";

$loop = React\EventLoop\Factory::create();

$instanceId = getenv("INSTANCE_ID");
$server = new StreamingServer([
    new LimitConcurrentRequestsMiddleware(20),
    new RequestBodyBufferMiddleware(2 * 1024 * 1024),
    new RequestBodyParserMiddleware(),
    new LimitConcurrentRequestsMiddleware(1),
    function (ServerRequestInterface $request) use ($instanceId) {
        file_put_contents("php://stdout", date("H:i:s") . " got request\n");
        return new Response(200, ['Content-Type' => 'text/plain'], "Hello World! from $instanceId\n");
    }
]);

file_put_contents("php://stdout", $instanceId . " starting server...\n");

$socket = new React\Socket\Server("0.0.0.0:9000", $loop);
$server->listen($socket);
$loop->run();