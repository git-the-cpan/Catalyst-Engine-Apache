#!perl

BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}


use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Catalyst::Test 'TestApp';

use Catalyst::Request;
use Catalyst::Request::Upload;
use HTTP::Headers;
use HTTP::Headers::Util 'split_header_words';
use HTTP::Request::Common;

{
    my $creq;

    my $request = POST(
        'http://localhost/dump/request/',
        'Content-Type' => 'form-data',
        'Content'      => [
            'author-live_engine_request_cookies.t' =>
              ["$FindBin::Bin/author-live_engine_request_cookies.t"],
            'author-live_engine_request_headers.t' =>
              ["$FindBin::Bin/author-live_engine_request_headers.t"],
            'author-live_engine_request_uploads.t' =>
              ["$FindBin::Bin/author-live_engine_request_uploads.t"],
        ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->content_type, 'text/plain', 'Response Content-Type' );
    like(
        $response->content,
        qr/^bless\( .* 'Catalyst::Request' \)$/s,
        'Content is a serialized Catalyst::Request'
    );

    {
        no strict 'refs';
        ok(
            eval '$creq = ' . $response->content,
            'Unserialize Catalyst::Request'
        );
    }

    isa_ok( $creq, 'Catalyst::Request' );
    is( $creq->method, 'POST', 'Catalyst::Request method' );
    is( $creq->content_type, 'multipart/form-data',
        'Catalyst::Request Content-Type' );
    is( $creq->content_length, $request->content_length,
        'Catalyst::Request Content-Length' );

    for my $part ( $request->parts ) {

        my $disposition = $part->header('Content-Disposition');
        my %parameters  = @{ ( split_header_words($disposition) )[0] };

        my $upload = $creq->{uploads}->{ $parameters{filename} };

        isa_ok( $upload, 'Catalyst::Request::Upload' );

        is( $upload->type, $part->content_type, 'Upload Content-Type' );
        is( $upload->size, length( $part->content ), 'Upload Content-Length' );

        # make sure upload is accessible via legacy params->{$file}
        is( $creq->{parameters}->{ $upload->filename },
            $upload->filename, 'legacy param method ok' );

        ok( !-e $upload->tempname, 'Upload temp file was deleted' );
    }
}

{
    my $creq;

    my $request = POST(
        'http://localhost/dump/request/',
        'Content-Type' => 'multipart/form-data',
        'Content'      => [
            'testfile' => ["$FindBin::Bin/author-live_engine_request_cookies.t"],
            'testfile' => ["$FindBin::Bin/author-live_engine_request_headers.t"],
            'testfile' => ["$FindBin::Bin/author-live_engine_request_uploads.t"],
        ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->content_type, 'text/plain', 'Response Content-Type' );
    like(
        $response->content,
        qr/^bless\( .* 'Catalyst::Request' \)$/s,
        'Content is a serialized Catalyst::Request'
    );

    {
        no strict 'refs';
        ok(
            eval '$creq = ' . $response->content,
            'Unserialize Catalyst::Request'
        );
    }

    isa_ok( $creq, 'Catalyst::Request' );
    is( $creq->method, 'POST', 'Catalyst::Request method' );
    is( $creq->content_type, 'multipart/form-data',
        'Catalyst::Request Content-Type' );
    is( $creq->content_length, $request->content_length,
        'Catalyst::Request Content-Length' );

    my @parts = $request->parts;

    for ( my $i = 0 ; $i < @parts ; $i++ ) {

        my $part        = $parts[$i];
        my $disposition = $part->header('Content-Disposition');
        my %parameters  = @{ ( split_header_words($disposition) )[0] };

        my $upload = $creq->{uploads}->{ $parameters{name} }->[$i];

        isa_ok( $upload, 'Catalyst::Request::Upload' );
        is( $upload->type, $part->content_type, 'Upload Content-Type' );
        is( $upload->filename, $parameters{filename}, 'Upload filename' );
        is( $upload->size, length( $part->content ), 'Upload Content-Length' );

        ok( !-e $upload->tempname, 'Upload temp file was deleted' );
    }
}

{
    my $creq;

    my $request = POST(
        'http://localhost/engine/request/uploads/slurp',
        'Content-Type' => 'multipart/form-data',
        'Content'      =>
          [ 'slurp' => ["$FindBin::Bin/author-live_engine_request_uploads.t"], ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->content_type, 'text/plain', 'Response Content-Type' );
    is( $response->content, ( $request->parts )[0]->content, 'Content' );
}

{
    my $request = POST(
        'http://localhost/dump/request',
        'Content-Type' => 'multipart/form-data',
        'Content'      =>
          [ 'file' => ["$FindBin::Bin/catalyst_130pix.gif"], ]
    );

    # LWP will auto-correct Content-Length when using a remote server
    SKIP:
    {
        if ( $ENV{CATALYST_SERVER} ) {
            skip 'Using remote server', 2;
        }

        # Sending wrong Content-Length here and see if subequent requests fail
        $request->header('Content-Length' => $request->header('Content-Length') + 1);

        ok( my $response = request($request), 'Request' );
        ok( !$response->is_success, 'Response Error' );
    }

    $request = POST(
        'http://localhost/dump/request',
        'Content-Type' => 'multipart/form-data',
        'Content'      =>
          [ 'file1' => ["$FindBin::Bin/catalyst_130pix.gif"],
            'file2' => ["$FindBin::Bin/catalyst_130pix.gif"], ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->content_type, 'text/plain', 'Response Content-Type' );
    like( $response->content, qr/file1 => bless/, 'Upload with name file1');
    like( $response->content, qr/file2 => bless/, 'Upload with name file2');
}

{
    my $creq;

    my $request = POST(
        'http://localhost/dump/request/',
        'Content-Type' => 'form-data',
        'Content'      => [
            'testfile' => 'textfield value',
            'testfile' => ["$FindBin::Bin/catalyst_130pix.gif"],
        ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->content_type, 'text/plain', 'Response Content-Type' );
    like(
        $response->content,
        qr/^bless\( .* 'Catalyst::Request' \)$/s,
        'Content is a serialized Catalyst::Request'
    );

    {
        no strict 'refs';
        ok(
            eval '$creq = ' . $response->content,
            'Unserialize Catalyst::Request'
        );
    }

    isa_ok( $creq, 'Catalyst::Request' );
    is( $creq->method, 'POST', 'Catalyst::Request method' );
    is( $creq->content_type, 'multipart/form-data',
        'Catalyst::Request Content-Type' );
    is( $creq->content_length, $request->content_length,
        'Catalyst::Request Content-Length' );

    my $param = $creq->{parameters}->{testfile};

    ok( @$param == 2, '2 values' );
    is( $param->[0], 'textfield value', 'correct value' );
    like( $param->[1], qr/\Qcatalyst_130pix.gif/, 'filename' );

    for my $part ( $request->parts ) {

        my $disposition = $part->header('Content-Disposition');
        my %parameters  = @{ ( split_header_words($disposition) )[0] };

        next unless exists $parameters{filename};

        my $upload = $creq->{uploads}->{ $parameters{name} };

        isa_ok( $upload, 'Catalyst::Request::Upload' );

        is( $upload->type, $part->content_type, 'Upload Content-Type' );
        is( $upload->size, length( $part->content ), 'Upload Content-Length' );
        is( $upload->filename, 'catalyst_130pix.gif' );
    }
}

done_testing;
