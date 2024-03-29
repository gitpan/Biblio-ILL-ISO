package Biblio::ILL::ISO::ExpiryFlag;

=head1 NAME

Biblio::ILL::ISO::ExpiryFlag

=cut

use Biblio::ILL::ISO::ILLASNtype;
use Biblio::ILL::ISO::ENUMERATED;
use Carp;

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
#---------------------------------------------------------------------------
# Mods
# 0.01 - 2003.07.15 - original version
#---------------------------------------------------------------------------

=head1 DESCRIPTION

Biblio::ILL::ISO::ExpiryFlag is a derivation of Biblio::ILL::ISO::ENUMERATED.

=head1 USES

 None.

=head1 USED IN

 Biblio::ILL::ISO::SearchType

=cut

BEGIN{@ISA = qw ( Biblio::ILL::ISO::ENUMERATED 
		  Biblio::ILL::ISO::ILLASNtype );}   # inherit from ILLASNtype

=head1 FROM THE ASN DEFINITION

  (part of Search-Type)

	expiry-flag	[2]	IMPLICIT ENUMERATED {
				need-Before-Date	(1),
				other-Date 		(2),
				no-Expiry 		(3)
				} -- DEFAULT 3,
				-- value of "need-Before-Date" indicates that
				-- need-before-date also specifies transaction expiry
				-- date

=cut

=head1 METHODS

=cut
#---------------------------------------------------------------
#
#---------------------------------------------------------------
=head1

=head2 new( $flag )

 Creates a new ExpiryFlag object. 
 Valid paramaters are listed in the FROM THE ASN DEFINITION section
 (e.g. "need-Before-Date").

=cut
sub new {
    my $class = shift;
    my $self = {};

    $self->{"ENUM_LIST"} = {"need-Before-Date" => 1,
			    "other-Date" => 2,
			    "no-Expiry" => 3
			    };

    if (@_) {
	my $s = shift;
	
	if ( exists $self->{"ENUM_LIST"}->{$s} ) {
	    $self->{"ENUMERATED"} = $self->{"ENUM_LIST"}->{$s};
	} else {
	    croak "invalid ExpiryList type: [$s]";
	}
    }

    bless($self, ref($class) || $class);
    return ($self);
}

=head1 SEE ALSO

See the README for system design notes.
See the parent class(es) for other available methods.

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
