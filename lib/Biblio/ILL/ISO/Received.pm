package Biblio::ILL::ISO::Received;

=head1 NAME

Biblio::ILL::ISO::Request - Perl extension for handling ISO 10161 interlibrary loan ILL-Request messages

=cut

use Biblio::ILL::ISO::ISO;
use Carp;

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
#---------------------------------------------------------------------------
# Mods
# 0.01 - 2003.08.11 - original version
#---------------------------------------------------------------------------

=head1 DESCRIPTION

Biblio::ILL::ISO::Received is a derivation of the abstract 
Biblio::ILL::ISO::ISO object, and handles the Received message type.

=head1 EXPORT

None.

=head1 ERROR HANDLING

Each of the set_() methods will croak on missing or invalid parameters.

=cut

BEGIN{@ISA = qw ( Biblio::ILL::ISO::ISO );  }

=head1 FROM THE ASN DEFINITION
 
 Received ::= [APPLICATION 8] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
			 -- version-1 (1),
			 -- version-2 (2)
			 -- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	supplier-id	[26]	IMPLICIT System-Id OPTIONAL,
 -- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
 --	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	date-received	[36]	IMPLICIT ISO-Date,
	shipped-service-type	[27]	IMPLICIT Shipped-Service-Type,
	requester-note	[46]	ILL-String OPTIONAL,
	received-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

=cut

=head1 CONSTRUCTORS

new()

Base constructor for the class. It just returns a completely
empty message object, which you'll need to populate with the
various set_() methods, or use the read() method to read an
Received message from a file (followed by a call to
from_asn() to turn the read's returned hash into a proper
Received message.

The constructor also initializes the Convert::ASN1 if it
hasn't been initialized.

=cut
#---------------------------------------------------------------
#
#---------------------------------------------------------------
sub new {
    my $class = shift;
    my $self = {};

    Biblio::ILL::ISO::ISO::_init() if (not $Biblio::ILL::ISO::ISO::_asn_initialized);
    $self->{"ASN_TYPE"} = "Received";

    bless($self, ref($class) || $class);
    return ($self);
}


#---------------------------------------------------------------
#
#---------------------------------------------------------------
sub as_pretty_string {
    my $self = shift;

    foreach my $key (sort keys %$self) {
	if ($key ne "ASN_TYPE") {
	    print "\n[$key]\n";
	    print $self->{$key}->as_pretty_string();
	}
    }
    return;
}

#---------------------------------------------------------------
# This will return a structure usable by Convert::ASN1
#---------------------------------------------------------------
sub as_asn {
    my $self = shift;

    my %h = ();
    foreach my $key (sort keys %$self) {
	if ($key ne "ASN_TYPE") {
	    #print "\n[$key]\n";
	    $h{$key} = $self->{$key}->as_asn();
	}
    }
    return \%h;
}

=head1 METHODS

For any example code, assume the following:
    my $msg = new Biblio::ILL::ISO::Received;

=cut

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 from_asn($href)

To read a message from a file, use the following:

    my $href = $msg->read("msg_08.received.ber");
    $msg = $msg->from_asn($href);

The from_asn() method turns the hash returned from read() into
a proper message-type object.

=cut
sub from_asn {
    my $self = shift;
    my $href = shift;

    foreach my $k (keys %$href) {

	if ($k =~ /^protocol-version-num$/) {
	    $self->{$k} = new Biblio::ILL::ISO::ProtocolVersionNum();
	    $self->{$k}->from_asn($href->{$k});

	} elsif ($k =~ /^transaction-id$/) {
	    $self->{$k} = new Biblio::ILL::ISO::TransactionId();
	    $self->{$k}->from_asn($href->{$k});

	} elsif ($k =~ /^service-date-time$/) {
	    $self->{$k} = new Biblio::ILL::ISO::ServiceDateTime();
	    $self->{$k}->from_asn($href->{$k});

	} elsif (($k =~ /^requester-id$/)
		 || ($k =~ /^responder-id$/)
		 || ($k =~ /^supplier-id$/)
		 ) {
	    $self->{$k} = new Biblio::ILL::ISO::SystemId();
	    $self->{$k}->from_asn($href->{$k});

	} elsif ($k =~ /^date-received$/) {
	    $self->{$k} = new Biblio::ILL::ISO::ISODate();
	    $self->{$k}->from_asn($href->{$k});

	} elsif ($k =~ /^shipped-service-type$/) {
	    $self->{$k} = new Biblio::ILL::ISO::ShippedServiceType();
	    $self->{$k}->from_asn($href->{$k});

	} elsif ($k =~ /^requester-note$/) {
	    $self->{$k} = new Biblio::ILL::ISO::ILLString();
	    $self->{$k}->from_asn($href->{$k});

	} else {
	    croak "invalid " . ref($self) . " element: [$k]";
	}

    }
    return $self;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_protocol_version_num($pvn)

 Sets the protocol version number.
 Acceptable parameter values are the strings:
    version-1
    version-2

=cut
sub set_protocol_version_num {
    my $self = shift;
    my ($parm) = shift;

    croak "missing protocol-version-num" unless $parm;

    $self->{"protocol-version-num"} = new Biblio::ILL::ISO::ProtocolVersionNum($parm);

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_transaction_id($tid)

 Sets the message's transaction-id.  
 Expects a valid Biblio::ILL::ISO::TransactionId.

    my $tid = new Biblio::ILL::ISO::TransactionId("PLS","001","", 
					          new Biblio::ILL::ISO::SystemId("MWPL"));
    $msg->set_transaction_id($tid);

 This is a mandatory field.

=cut
sub set_transaction_id {
    my $self = shift;
    my ($parm) = shift;

    croak "missing transaction-id" unless $parm;
    croak "invalid transaction-id" unless (ref($parm) eq "Biblio::ILL::ISO::TransactionId");

    $self->{"transaction-id"} = $parm;

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_service_date_time($sdt)

 Sets the message's service-date-time.  
 Expects a valid Biblio::ILL::ISO::ServiceDateTime.

    my $dt_this = new Biblio::ILL::ISO::DateTime("20030623","114400");
    my $dt_orig = new Biblio::ILL::ISO::DateTime("20030623","114015")
    my $sdt = new Biblio::ILL::ISO::ServiceDateTime( $dt_this, $dt_orig);
    $msg->set_service_date_time($sdt);

 This is a mandatory field.

=cut
sub set_service_date_time {
    my $self = shift;
    my ($sdt) = shift;

    croak "missing service-date-time" unless $sdt;
    croak "invalid service-date-time" unless (ref($sdt) eq "Biblio::ILL::ISO::ServiceDateTime");

    $self->{"service-date-time"} = $sdt;

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_requester_id($reqid)

 Sets the message's requester-id.  
 Expects a valid Biblio::ILL::ISO::SystemId.

    my $reqid = new Biblio::ILL::ISO::SystemId();
    $reqid->set_person_name("David A. Christensen");
    $msg->set_requester_id($reqid);

 This is an optional field.

=cut
sub set_requester_id {
    my $self = shift;
    my ($parm) = shift;

    croak "missing requester-id" unless $parm;
    croak "invalid requester-id" unless (ref($parm) eq "Biblio::ILL::ISO::SystemId");

    $self->{"requester-id"} = $parm;

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_responder_id($resid)

 Sets the message's responder-id.  
 Expects a valid Biblio::ILL::ISO::SystemId.

    my $resid = new Biblio::ILL::ISO::SystemId("MWPL");
    $msg->set_responder_id($resid);

 This is an optional field.

=cut
sub set_responder_id {
    my $self = shift;
    my ($parm) = shift;

    croak "missing responder-id" unless $parm;
    croak "invalid responder-id" unless (ref($parm) eq "Biblio::ILL::ISO::SystemId");

    $self->{"responder-id"} = $parm;

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_supplier_id($sid)

 Sets the message's supplier-id.
 Expects a valid Biblio::ILL::ISO::SystemId.

    my $sid = new Biblio::ILL::ISO::SystemId("MBOM");
    $msg->set_supplier_id($sid);

 This is an optional field.

=cut
sub set_supplier_id {
    my $self = shift;
    my ($parm) = shift;

    croak "missing supplier-id" unless $parm;
    croak "invalid supplier-id" unless (ref($parm) eq "Biblio::ILL::ISO::SystemId");

    $self->{"supplier-id"} = $parm;

    return;
}

#---------------------------------------------------------------
#  This is EXTERNAL, which we don't handle
#---------------------------------------------------------------
#sub set_supplemental_item_description {
#    my $self = shift;
#    my ($parm) = shift;
#
#    croak "missing supplemental-item-description" unless $parm;
#    croak "invalid supplemental-item-description" unless (ref($parm) eq "Biblio::ILL::ISO::SupplementalItemDescription");
#
#    $self->{"supplemental-item-description"} = $parm;
#
#    return;
#}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_date_received($dr)

 Sets the message's date-received.
 Expects a valid Biblio::ILL::ISO::ISODate.

    my $dr = new Biblio::ILL::ISO::ISODate("20030813");
    $msg->set_date_received($dr);

 This is a mandatory field.

=cut
sub set_date_received {
    my $self = shift;
    my ($parm) = shift;

    if (ref($parm) eq "Biblio::ILL::ISO::ISODate") {
	$self->{"date-received"} = $parm;
    } else {
	# ISODate does the error checking....
	$self->{"date-received"} = new Biblio::ILL::ISO::ISODate($parm);
    }

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_shipped_service_type($sst)

 Sets the message's shipped-service-type.
 Expects a valid Biblio::ILL::ISO::ShippedServiceType.

    my $sst = new Biblio::ILL::ISO::ShippedServiceType("loan");
    $msg->set_shipped_service_type($sst);

 This is a mandatory field.

=cut
sub set_shipped_service_type {
    my $self = shift;
    my ($parm) = shift;

    croak "missing shipped-service-type" unless $parm;
    croak "invalid shipped-service-type" unless (ref($parm) eq "Biblio::ILL::ISO::ShippedServiceType");

    $self->{"shipped-service-type"} = $parm;

    return;
}

#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 set_requester_note($note)

 Sets the message's requester-note.
 Expects a simple text string.

    $msg->set_requester_note("This is a requester note");

 This is an optional field.

=cut
sub set_requester_note {
    my $self = shift;
    my ($parm) = shift;

    croak "missing requester-note" unless $parm;
    croak "invalid requester-note" unless (ref($parm) eq "Biblio::ILL::ISO::ILLString");

    $self->{"requester-note"} = $parm;

    return;
}

=head1 RELATED MODULES

 Biblio::ILL::ISO::ISO
 Biblio::ILL::ISO::Request
 Biblio::ILL::ISO::ForwardNotification
 Biblio::ILL::ISO::Shipped
 Biblio::ILL::ISO::Answer
 Biblio::ILL::ISO::ConditionalReply
 Biblio::ILL::ISO::Cancel
 Biblio::ILL::ISO::CancelReply
 Biblio::ILL::ISO::Received
 Biblio::ILL::ISO::Recall
 Biblio::ILL::ISO::Returned
 Biblio::ILL::ISO::CheckedIn
 Biblio::ILL::ISO::Overdue
 Biblio::ILL::ISO::Renew
 Biblio::ILL::ISO::RenewAnswer
 Biblio::ILL::ISO::Lost
 Biblio::ILL::ISO::Damaged
 Biblio::ILL::ISO::Message
 Biblio::ILL::ISO::StatusQuery
 Biblio::ILL::ISO::StatusOrErrorReport
 Biblio::ILL::ISO::Expired

=cut

=head1 SEE ALSO

See the README for system design notes.

For more information on Interlibrary Loan standards (ISO 10160/10161),
a good place to start is:

http://www.nlc-bnc.ca/iso/ill/main.htm

=cut

=head1 AUTHOR

David Christensen, <DChristensenSPAMLESS@westman.wave.ca>

=cut


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by David Christensen

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
