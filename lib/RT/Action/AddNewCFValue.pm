package RT::Action::AddNewCFValue;

use strict;
use warnings;

use base qw(RT::Action);

sub Prepare {
    return 1;
}

=head2 DESCRIPTION

If the current value provided for this custom field isn't currently in
the list of available values, add it.

The custom field name is identified by the Argument set for the scrip
action when the action is installed.

=cut

sub Commit {
    my $self   = shift;
    my $txn    = $self->TransactionObj;
    my $cf_name = $self->Argument;

    my $cf = $self->TicketObj->LoadCustomFieldByIdentifier($cf_name);
    RT::Logger->error("Unable to load custom field $cf_name") unless $cf->Id;

    my $values_obj = $cf->Values;
    my @current_values;
    while ( my $cf_value = $values_obj->Next ){
        push @current_values, $cf_value->Name;
    }

    if ( $txn->Type eq 'Create') {
        # Can get multiple new values from create, so check them all
        my @ticket_values =
            split /\n/, $self->TicketObj->CustomFieldValuesAsString($cf_name);

        foreach my $value ( @ticket_values ){
            # Already got it
            next if grep {$value eq $_} @current_values;

            # Don't have it, so add it
            $cf->AddValue( Name => $value );
        }
        return 1;
    }
    else{
        # CF update transaction
        my $cf_value = $self->NewReferenceObject($txn);
        if ( not $cf_value->Id ){
            RT::Logger->error("Unable to load referenced transaction object "
            . "for transaction " . $txn->Id);
            return 0;
        }

        foreach my $value ( @current_values ){
            # Already have it
            warn "Content is: " . $cf_value->Content;
            warn "Value is: $value";
            return 1 if $cf_value->Content eq $value;
        }

        # It's new, add it
        $cf->AddValue( Name => $cf_value->Content );
        return 1;
    }
}

# Lifted from later RT for compatibility with RT 4.0. Can be removed
# after 4.0 support drops.

sub NewReferenceObject {
    my $self  = shift;
    my $txn = shift;
    my $type  = $txn->__Value("ReferenceType");
    my $id    = $txn->__Value("NewReference");
    return unless $type and $id;

    my $object = $type->new($self->CurrentUser);
    $object->Load( $id );
    return $object;
}

1;
