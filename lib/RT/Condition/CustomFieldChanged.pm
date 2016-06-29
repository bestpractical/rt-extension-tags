package RT::Condition::CustomFieldChanged;

use strict;
use warnings;
use base qw(RT::Condition);

=head2 Custom Field Changed

Is a custom field being changed with this transaction?

=cut

sub IsApplicable {
    my $self = shift;

    # Should be installed with ApplicableTransTypes of Create,CustomField,
    # so return true for those types.
    warn "Trans type is: " . $self->TransactionObj->Type;
    return 1;
}

1;
