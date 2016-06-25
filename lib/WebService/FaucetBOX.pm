use strict;
use warnings;
package WebService::FaucetBOX;

# ABSTRACT: WebService::FaucetBOX - FaucetBOX (faucetbox.com) API bindings

use Moo;
with 'WebService::Client';

use Function::Parameters;

=head1 SYNOPSIS

    my $faucetbox = WebService::FaucetBOX->new(
        api_key    => 'abc',
        currency   => 'BTC', # optional, defaults to BTC
        logger     => Log::Tiny->new('/tmp/foo.log'), # optional
        log_method => 'info', # optional, defaults to 'DEBUG'
        timeout    => 10, # optional, defaults to 10
        retries    => 0,  # optional, defaults to 0
    );

    # To send 500 satoshi to address
    my $result = $faucetbox->send("1asdbitcoinaddressheredsa", 500);

See L<https://faucetbox.com/en/api> for call arguments

=cut

# sub BUILD {
#   my ($self) = @_;
#   $self->ua->add_handler("request_send",  sub { shift->dump; return });
#   $self->ua->add_handler("response_done", sub { shift->dump; return });
# }

around post => fun($orig, $self, $path, $params, %args) {
    $params->{api_key}               = $self->api_key;
    $params->{currency}              = $self->currency;
    $args{headers}->{'Content-Type'} = 'application/x-www-form-urlencoded';
    return $self->$orig($path, $params, %args);
};

=method base_url

=cut

has '+base_url' => ( default => 'https://faucetbox.com/api/v1' );

=method currency

=cut

has currency => ( is => 'rw', default => 'BTC' );

=method auth_token

=cut

has api_key => ( is => 'ro', required => 1 );


=method send

=cut

method send($to, $amount, :$referral = 'false') {
  return $self->post("/send", {
    to       => $to,
    amount   => $amount,
    referral => $referral
  });
}

=method getBalance

=cut

method getBalance {
  return $self->post( "/balance" );
}

=method getBalance

=cut

method getCurrencies {
  return $self->post( "/currencies" );
}

=method getPayouts

=cut

method getPayouts( $count ) {
  return $self->post( "/payouts", { count => $count } );
}

=method sendReferralEarnings

=cut

method sendReferralEarnings( $to, $amount ) {
  return $self->send($to, $amount, 'true');
}

=head1 SEE ALSO

=over 4

=item *

L<WebService::Client>

=back

=cut

1;
