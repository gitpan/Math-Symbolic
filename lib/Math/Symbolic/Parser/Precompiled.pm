
=head1 NAME

Math::Symbolic::Parser::Precompiled - Precompiled Math::Symbolic Parser

=head1 DESCRIPTION

This module is a precompiled version of the Parse::RecDescent grammar
that can be found in $Math::Symbolic::Parser::Grammar. It is used internally
to improve startup performance. Please use the new() method in the
Math::Symbolic::Parser namespace to generate new parsers.

=head1 AUTHOR

Please send feedback, bug reports, and support requests to the Math::Symbolic
support mailing list:
math-symbolic-support at lists dot sourceforge dot net. Please
consider letting us know how you use Math::Symbolic. Thank you.

If you're interested in helping with the development or extending the
module's functionality, please contact the developers' mailing list:
math-symbolic-develop at lists dot sourceforge dot net.

List of contributors:

  Steffen Müller, symbolic-module at steffen-mueller dot net
  Stray Toaster, mwk at users dot sourceforge dot net
  Oliver Ebenhöh

=head1 SEE ALSO

New versions of this module can be found on
http://steffen-mueller.net or CPAN. The module development takes place on
Sourceforge at http://sourceforge.net/projects/math-symbolic/

L<Math::Symbolic>

L<Math::Symbolic::Parser>

=cut

package Math::Symbolic::Parser::Precompiled;
our $VERSION = '0.131';
use Parse::RecDescent;

{
    my $ERRORS;

    package Parse::RecDescent::Math::Symbolic::Parser::Precompiled;
    use strict;
    use vars qw($skip $AUTOLOAD  );
    $skip = '\s*';

    {
        local $SIG{__WARN__} = sub { 0 };

        # PRETEND TO BE IN Parse::RecDescent NAMESPACE
        *Parse::RecDescent::Math::Symbolic::Parser::Precompiled::AUTOLOAD =
          sub {
            no strict 'refs';
            $AUTOLOAD =~
s/^Parse::RecDescent::Math::Symbolic::Parser::Precompiled/Parse::RecDescent/;
            goto &{$AUTOLOAD};
          }
    }

    push @Parse::RecDescent::Math::Symbolic::Parser::Precompiled::ISA,
      'Parse::RecDescent';

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::parse {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"parse"};

        Parse::RecDescent::_trace(
            q{Trying rule: [parse]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{parse}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [expr]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{parse});
            %item = ( __RULE__ => q{parse} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [expr]},
                Parse::RecDescent::_tracefirst($text),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [expr]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{parse}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                        q{>>Matched subrule: [expr]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{parse},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{expr}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{>>Matched production: [expr]<<},
                Parse::RecDescent::_tracefirst($text),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched ) {

            Parse::RecDescent::_trace(
                q{Trying production: [<error...>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];

            my $_savetext;
            @item = (q{parse});
            %item = ( __RULE__ => q{parse} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying directive: [<error...>]},
                Parse::RecDescent::_tracefirst($text),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_tok = do {
                if (1) {
                    do {
                        my $rule = $item[0];
                        $rule =~ s/_/ /g;

#WAS: Parse::RecDescent::_error("Invalid $rule: " . $expectation->message() ,$thisline);
                        push @{ $thisparser->{errors} },
                          [
                            "Invalid $rule: " . $expectation->message(),
                            $thisline
                          ];
                    } unless $_noactions;
                    undef;
                }
                else { 0 }
            };
            if ( defined($_tok) ) {
                Parse::RecDescent::_trace(
                    q{>>Matched directive<< (return value: [} . $_tok . q{])},
                    Parse::RecDescent::_tracefirst($text) )
                  if defined $::RD_TRACE;
            }
            else {
                Parse::RecDescent::_trace(
                    q{<<Didn't match directive>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
            }

            last unless defined $_tok;
            push @item, $item{__DIRECTIVE1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [<error...>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{parse}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{parse}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{parse}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{parse},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr_list {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"expr_list"};

        Parse::RecDescent::_trace(
            q{Trying rule: [expr_list]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{expr_list}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [<leftop: expr list_op expr>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{expr_list}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{expr_list});
            %item = ( __RULE__ => q{expr_list} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying operator: [<leftop: expr list_op expr>]},
                Parse::RecDescent::_tracefirst($text),
                q{expr_list}, $tracelevel
              )
              if defined $::RD_TRACE;
            $expectation->is(q{})->at($text);

            $_tok = undef;
          OPLOOP: while (1) {
                $repcount = 0;
                my @item;

                # MATCH LEFTARG

                Parse::RecDescent::_trace(
                    q{Trying subrule: [expr]},
                    Parse::RecDescent::_tracefirst($text),
                    q{expr_list}, $tracelevel
                  )
                  if defined $::RD_TRACE;
                if (1) {
                    no strict qw{refs};
                    $expectation->is(q{expr})->at($text);
                    unless (
                        defined(
                            $_tok =
                              Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr
                              (
                                $thisparser, $text, $repeating,
                                $_noactions, sub    { \@arg }
                              )
                        )
                      )
                    {

                        Parse::RecDescent::_trace(
                            q{<<Didn't match subrule: [expr]>>},
                            Parse::RecDescent::_tracefirst($text),
                            q{expr_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $expectation->failed();
                        last;
                    }
                    Parse::RecDescent::_trace(
                        q{>>Matched subrule: [expr]<< (return value: [} . $_tok
                          . q{]},

                        Parse::RecDescent::_tracefirst($text),
                        q{expr_list},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $item{q{expr}} = $_tok;
                    push @item, $_tok;

                }

                $repcount++;

                my $savetext = $text;
                my $backtrack;

                # MATCH (OP RIGHTARG)(s)
                while ( $repcount < 100000000 ) {
                    $backtrack = 0;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [list_op]},
                        Parse::RecDescent::_tracefirst($text),
                        q{expr_list}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{list_op})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::list_op
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [list_op]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{expr_list},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [list_op]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{expr_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{list_op}} = $_tok;
                        push @item, $_tok;

                    }

                    $backtrack = 1;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [expr]},
                        Parse::RecDescent::_tracefirst($text),
                        q{expr_list}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{expr})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [expr]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{expr_list},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [expr]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{expr_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{expr}} = $_tok;
                        push @item, $_tok;

                    }

                    $savetext = $text;
                    $repcount++;
                }
                $text = $savetext;
                pop @item if $backtrack;

                unless (@item) { undef $_tok; last }
                $_tok = [@item];
                last;
            }

            unless ( $repcount >= 1 ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match operator: [<leftop: expr list_op expr>]>>},
                    Parse::RecDescent::_tracefirst($text),
                    q{expr_list},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $expectation->failed();
                last;
            }
            Parse::RecDescent::_trace(
q{>>Matched operator: [<leftop: expr list_op expr>]<< (return value: [}
                  . qq{@{$_tok||[]}} . q{]},
                Parse::RecDescent::_tracefirst($text),
                q{expr_list},
                $tracelevel
              )
              if defined $::RD_TRACE;

            push @item, $item{__DIRECTIVE1__} = $_tok || [];

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{expr_list}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'expr_list '
                  if $Math::Symbolic::Parser::DEBUG;
                my $i = 1;
                [ grep { $i == 1 ? ( --$i, 1 ) : ( ++$i, 0 ) } @{ $item[1] } ];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [<leftop: expr list_op expr>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{expr_list}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{expr_list}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{expr_list}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{expr_list}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{expr_list},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::number {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"number"};

        Parse::RecDescent::_trace(
            q{Trying rule: [number]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{number}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [/\\d+(\\.\\d+)?/]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{number}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{number});
            %item = ( __RULE__ => q{number} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: [/\\d+(\\.\\d+)?/]},
                Parse::RecDescent::_tracefirst($text),
                q{number}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A(?:\d+(\.\d+)?)// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace( q{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text) )
                  if defined $::RD_TRACE;

                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__PATTERN1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{number}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'number '
                  if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Constant->new( $item[1] );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [/\\d+(\\.\\d+)?/]<<},
                Parse::RecDescent::_tracefirst($text),
                q{number}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{number}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{number}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{number}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{number},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::add_op {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"add_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [add_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{add_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['+']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{add_op});
            %item = ( __RULE__ => q{add_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['+']},
                Parse::RecDescent::_tracefirst($text),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\+// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['+']<<},
                Parse::RecDescent::_tracefirst($text),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['-']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{add_op});
            %item = ( __RULE__ => q{add_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['-']},
                Parse::RecDescent::_tracefirst($text),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\-// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['-']<<},
                Parse::RecDescent::_tracefirst($text),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{add_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{add_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{add_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{add_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::mult_op {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"mult_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [mult_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{mult_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['*']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{mult_op});
            %item = ( __RULE__ => q{mult_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['*']},
                Parse::RecDescent::_tracefirst($text),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\*// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['*']<<},
                Parse::RecDescent::_tracefirst($text),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['/']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{mult_op});
            %item = ( __RULE__ => q{mult_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['/']},
                Parse::RecDescent::_tracefirst($text),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\/// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['/']<<},
                Parse::RecDescent::_tracefirst($text),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{mult_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{mult_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{mult_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{mult_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::variable {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"variable"};

        Parse::RecDescent::_trace(
            q{Trying rule: [variable]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{variable}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [identifier '(' identifier_list ')']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{variable},
                $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{variable});
            %item = ( __RULE__ => q{variable} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [identifier]},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [identifier]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{variable}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [identifier]<< (return value: [}
                      . $_tok . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{variable},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{identifier}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying terminal: ['(']},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{'('})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\(// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying subrule: [identifier_list]},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{identifier_list})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier_list
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [identifier_list]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{variable},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [identifier_list]<< (return value: [}
                      . $_tok . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{variable},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{identifier_list}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying terminal: [')']},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{')'})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\)// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING2__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'variable '
                  if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Variable->new(
                    {
                        name      => $item[1],
                        signature => $item[3],
                    }
                );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [identifier '(' identifier_list ')']<<},
                Parse::RecDescent::_tracefirst($text),
                q{variable},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [identifier]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{variable});
            %item = ( __RULE__ => q{variable} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [identifier]},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [identifier]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{variable}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [identifier]<< (return value: [}
                      . $_tok . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{variable},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{identifier}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'variable '
                  if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Variable->new( { name => $item[1], } );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [identifier]<<},
                Parse::RecDescent::_tracefirst($text),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{variable}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{variable}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{variable}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{variable},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"unary"};

        Parse::RecDescent::_trace(
            q{Trying rule: [unary]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{unary}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [forced_unary_op factor]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{unary});
            %item = ( __RULE__ => q{unary} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [forced_unary_op]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::forced_unary_op
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [forced_unary_op]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [forced_unary_op]<< (return value: [}
                      . $_tok . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{forced_unary_op}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying subrule: [factor]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{factor})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::factor
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [factor]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [factor]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{factor}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'unary '
                  if $Math::Symbolic::Parser::DEBUG;
                if ( $item[1] and $item[1] eq '-' ) {
                    Math::Symbolic::Operator->new(
                        {
                            type     => Math::Symbolic::U_MINUS,
                            operands => [ $item[2] ],
                        }
                    );
                }
                else {
                    $item[2];
                }
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [forced_unary_op factor]<<},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [unary_op number]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{unary});
            %item = ( __RULE__ => q{unary} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [unary_op]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary_op
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [unary_op]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [unary_op]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{unary_op}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying subrule: [number]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{number})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::number
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [number]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [number]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{number}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'unary '
                  if $Math::Symbolic::Parser::DEBUG;
                if ( $item[1] and $item[1] eq '-' ) {
                    Math::Symbolic::Operator->new(
                        {
                            type     => Math::Symbolic::U_MINUS,
                            operands => [ $item[2] ],
                        }
                    );
                }
                else {
                    $item[2];
                }
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [unary_op number]<<},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [unary_op function]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[2];
            $text = $_[1];
            my $_savetext;
            @item = (q{unary});
            %item = ( __RULE__ => q{unary} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [unary_op]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary_op
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [unary_op]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [unary_op]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{unary_op}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying subrule: [function]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{function})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::function
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [function]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [function]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{function}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'unary '
                  if $Math::Symbolic::Parser::DEBUG;
                if ( $item[1] and $item[1] eq '-' ) {
                    Math::Symbolic::Operator->new(
                        {
                            type     => Math::Symbolic::U_MINUS,
                            operands => [ $item[2] ],
                        }
                    );
                }
                else {
                    $item[2];
                }
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [unary_op function]<<},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [unary_op variable]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[3];
            $text = $_[1];
            my $_savetext;
            @item = (q{unary});
            %item = ( __RULE__ => q{unary} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [unary_op]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary_op
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [unary_op]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [unary_op]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{unary_op}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying subrule: [variable]},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{variable})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::variable
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [variable]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{unary}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [variable]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{unary},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{variable}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'unary '
                  if $Math::Symbolic::Parser::DEBUG;
                if ( $item[1] and $item[1] eq '-' ) {
                    Math::Symbolic::Operator->new(
                        {
                            type     => Math::Symbolic::U_MINUS,
                            operands => [ $item[2] ],
                        }
                    );
                }
                else {
                    $item[2];
                }
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [unary_op variable]<<},
                Parse::RecDescent::_tracefirst($text),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{unary}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{unary}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{unary},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::factor {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"factor"};

        Parse::RecDescent::_trace(
            q{Trying rule: [factor]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{factor}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [unary]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{factor});
            %item = ( __RULE__ => q{factor} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [unary]},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [unary]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{factor}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                        q{>>Matched subrule: [unary]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{factor},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{unary}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'factor '
                  if $Math::Symolic::Parser::DEBUG;
                $item[1];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [unary]<<},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['(' expr ')']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{factor});
            %item = ( __RULE__ => q{factor} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['(']},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\(// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying subrule: [expr]},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{expr})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [expr]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{factor}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                        q{>>Matched subrule: [expr]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{factor},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{expr}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying terminal: [')']},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{')'})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\)// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING2__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'factor '
                  if $Math::Symbolic::Parser::DEBUG;
                $item[2];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['(' expr ')']<<},
                Parse::RecDescent::_tracefirst($text),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{factor}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{factor}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{factor}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{factor},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::unary_op {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"unary_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [unary_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{unary_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [/([+-]?)/]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{unary_op});
            %item = ( __RULE__ => q{unary_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: [/([+-]?)/]},
                Parse::RecDescent::_tracefirst($text),
                q{unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A(?:([+-]?))// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace( q{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text) )
                  if defined $::RD_TRACE;

                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__PATTERN1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                $item[1];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [/([+-]?)/]<<},
                Parse::RecDescent::_tracefirst($text),
                q{unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{unary_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{unary_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{unary_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::exp_op {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"exp_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [exp_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{exp_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['^']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{exp_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{exp_op});
            %item = ( __RULE__ => q{exp_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['^']},
                Parse::RecDescent::_tracefirst($text),
                q{exp_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\^// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['^']<<},
                Parse::RecDescent::_tracefirst($text),
                q{exp_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{exp_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{exp_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{exp_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{exp_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::function {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"function"};

        Parse::RecDescent::_trace(
            q{Trying rule: [function]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{function}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [function_name '(' expr_list ')']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{function});
            %item = ( __RULE__ => q{function} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [function_name]},
                Parse::RecDescent::_tracefirst($text),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::function_name
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [function_name]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{function},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [function_name]<< (return value: [}
                      . $_tok . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{function},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{function_name}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying terminal: ['(']},
                Parse::RecDescent::_tracefirst($text),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{'('})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\(// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying subrule: [expr_list]},
                Parse::RecDescent::_tracefirst($text),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{expr_list})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr_list
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [expr_list]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{function}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [expr_list]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{function},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{expr_list}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying terminal: [')']},
                Parse::RecDescent::_tracefirst($text),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{')'})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\)// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING2__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'function '
                  if $Math::Symbolic::Parser::DEBUG;
                my $function =
                  $Math::Symbolic::Operator::Op_Symbols{ $item[1] };
                die "Invalid function '$item[1]'!"
                  unless defined $function;

                Math::Symbolic::Operator->new(
                    {
                        type     => $function,
                        operands => $item[3],
                    }
                );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [function_name '(' expr_list ')']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{function}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{function}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{function},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::exp {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"exp"};

        Parse::RecDescent::_trace(
            q{Trying rule: [exp]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{exp}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [<rightop: factor exp_op factor>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{exp}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{exp});
            %item = ( __RULE__ => q{exp} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying operator: [<rightop: factor exp_op factor>]},
                Parse::RecDescent::_tracefirst($text),
                q{exp}, $tracelevel
              )
              if defined $::RD_TRACE;
            $expectation->is(q{})->at($text);

            $_tok = undef;
          OPLOOP: while (1) {
                $repcount = 0;
                my @item;

                my $savetext = $text;
                my $backtrack;

                # MATCH (LEFTARG OP)(s)
                while ( $repcount < 100000000 ) {
                    $backtrack = 0;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [factor]},
                        Parse::RecDescent::_tracefirst($text),
                        q{exp}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{factor})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::factor
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [factor]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{exp},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [factor]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{exp},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{factor}} = $_tok;
                        push @item, $_tok;

                    }

                    $repcount++;
                    $backtrack = 1;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [exp_op]},
                        Parse::RecDescent::_tracefirst($text),
                        q{exp}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{exp_op})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::exp_op
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [exp_op]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{exp},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [exp_op]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{exp},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{exp_op}} = $_tok;
                        push @item, $_tok;

                    }

                    $savetext = $text;

                }
                $text = $savetext;
                pop @item if $backtrack;

                # MATCH RIGHTARG

                Parse::RecDescent::_trace(
                    q{Trying subrule: [factor]},
                    Parse::RecDescent::_tracefirst($text),
                    q{exp}, $tracelevel
                  )
                  if defined $::RD_TRACE;
                if (1) {
                    no strict qw{refs};
                    $expectation->is(q{factor})->at($text);
                    unless (
                        defined(
                            $_tok =
                              Parse::RecDescent::Math::Symbolic::Parser::Precompiled::factor
                              (
                                $thisparser, $text, $repeating,
                                $_noactions, sub    { \@arg }
                              )
                        )
                      )
                    {

                        Parse::RecDescent::_trace(
                            q{<<Didn't match subrule: [factor]>>},
                            Parse::RecDescent::_tracefirst($text),
                            q{exp}, $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $expectation->failed();
                        last;
                    }
                    Parse::RecDescent::_trace(
                        q{>>Matched subrule: [factor]<< (return value: [}
                          . $_tok . q{]},

                        Parse::RecDescent::_tracefirst($text),
                        q{exp},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $item{q{factor}} = $_tok;
                    push @item, $_tok;

                }

                $repcount++;
                unless (@item) { undef $_tok; last }
                $_tok = [@item];
                last;
            }

            unless ( $repcount >= 1 ) {
                Parse::RecDescent::_trace(
q{<<Didn't match operator: [<rightop: factor exp_op factor>]>>},
                    Parse::RecDescent::_tracefirst($text),
                    q{exp},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $expectation->failed();
                last;
            }
            Parse::RecDescent::_trace(
q{>>Matched operator: [<rightop: factor exp_op factor>]<< (return value: [}
                  . qq{@{$_tok||[]}} . q{]},
                Parse::RecDescent::_tracefirst($text),
                q{exp},
                $tracelevel
              )
              if defined $::RD_TRACE;

            push @item, $item{__DIRECTIVE1__} = $_tok || [];

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{exp}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'exp ' if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Parser::_left_right_op_list( 'exp', @item );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [<rightop: factor exp_op factor>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{exp}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{exp}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{exp}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{exp}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{exp},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::multiplication {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"multiplication"};

        Parse::RecDescent::_trace(
            q{Trying rule: [multiplication]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{multiplication}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [<leftop: exp mult_op exp>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{multiplication}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{multiplication});
            %item = ( __RULE__ => q{multiplication} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying operator: [<leftop: exp mult_op exp>]},
                Parse::RecDescent::_tracefirst($text),
                q{multiplication}, $tracelevel
              )
              if defined $::RD_TRACE;
            $expectation->is(q{})->at($text);

            $_tok = undef;
          OPLOOP: while (1) {
                $repcount = 0;
                my @item;

                # MATCH LEFTARG

                Parse::RecDescent::_trace(
                    q{Trying subrule: [exp]},
                    Parse::RecDescent::_tracefirst($text),
                    q{multiplication}, $tracelevel
                  )
                  if defined $::RD_TRACE;
                if (1) {
                    no strict qw{refs};
                    $expectation->is(q{exp})->at($text);
                    unless (
                        defined(
                            $_tok =
                              Parse::RecDescent::Math::Symbolic::Parser::Precompiled::exp
                              (
                                $thisparser, $text, $repeating,
                                $_noactions, sub    { \@arg }
                              )
                        )
                      )
                    {

                        Parse::RecDescent::_trace(
                            q{<<Didn't match subrule: [exp]>>},
                            Parse::RecDescent::_tracefirst($text),
                            q{multiplication},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $expectation->failed();
                        last;
                    }
                    Parse::RecDescent::_trace(
                        q{>>Matched subrule: [exp]<< (return value: [} . $_tok
                          . q{]},

                        Parse::RecDescent::_tracefirst($text),
                        q{multiplication},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $item{q{exp}} = $_tok;
                    push @item, $_tok;

                }

                $repcount++;

                my $savetext = $text;
                my $backtrack;

                # MATCH (OP RIGHTARG)(s)
                while ( $repcount < 100000000 ) {
                    $backtrack = 0;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [mult_op]},
                        Parse::RecDescent::_tracefirst($text),
                        q{multiplication}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{mult_op})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::mult_op
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [mult_op]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{multiplication},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [mult_op]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{multiplication},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{mult_op}} = $_tok;
                        push @item, $_tok;

                    }

                    $backtrack = 1;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [exp]},
                        Parse::RecDescent::_tracefirst($text),
                        q{multiplication}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{exp})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::exp
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [exp]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{multiplication},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [exp]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{multiplication},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{exp}} = $_tok;
                        push @item, $_tok;

                    }

                    $savetext = $text;
                    $repcount++;
                }
                $text = $savetext;
                pop @item if $backtrack;

                unless (@item) { undef $_tok; last }
                $_tok = [@item];
                last;
            }

            unless ( $repcount >= 1 ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match operator: [<leftop: exp mult_op exp>]>>},
                    Parse::RecDescent::_tracefirst($text),
                    q{multiplication},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $expectation->failed();
                last;
            }
            Parse::RecDescent::_trace(
q{>>Matched operator: [<leftop: exp mult_op exp>]<< (return value: [}
                  . qq{@{$_tok||[]}} . q{]},
                Parse::RecDescent::_tracefirst($text),
                q{multiplication},
                $tracelevel
              )
              if defined $::RD_TRACE;

            push @item, $item{__DIRECTIVE1__} = $_tok || [];

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{multiplication}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'multiplication '
                  if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Parser::_left_right_op_list( 'multiplication',
                    @item );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [<leftop: exp mult_op exp>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{multiplication},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{multiplication}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{multiplication}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{multiplication}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{multiplication},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::addition {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"addition"};

        Parse::RecDescent::_trace(
            q{Trying rule: [addition]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{addition}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
q{Trying production: [<leftop: multiplication add_op multiplication>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{addition},
                $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{addition});
            %item = ( __RULE__ => q{addition} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
q{Trying operator: [<leftop: multiplication add_op multiplication>]},
                Parse::RecDescent::_tracefirst($text),
                q{addition},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $expectation->is(q{})->at($text);

            $_tok = undef;
          OPLOOP: while (1) {
                $repcount = 0;
                my @item;

                # MATCH LEFTARG

                Parse::RecDescent::_trace(
                    q{Trying subrule: [multiplication]},
                    Parse::RecDescent::_tracefirst($text),
                    q{addition}, $tracelevel
                  )
                  if defined $::RD_TRACE;
                if (1) {
                    no strict qw{refs};
                    $expectation->is(q{multiplication})->at($text);
                    unless (
                        defined(
                            $_tok =
                              Parse::RecDescent::Math::Symbolic::Parser::Precompiled::multiplication
                              (
                                $thisparser, $text, $repeating,
                                $_noactions, sub    { \@arg }
                              )
                        )
                      )
                    {

                        Parse::RecDescent::_trace(
                            q{<<Didn't match subrule: [multiplication]>>},
                            Parse::RecDescent::_tracefirst($text),
                            q{addition},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $expectation->failed();
                        last;
                    }
                    Parse::RecDescent::_trace(
q{>>Matched subrule: [multiplication]<< (return value: [}
                          . $_tok . q{]},

                        Parse::RecDescent::_tracefirst($text),
                        q{addition},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $item{q{multiplication}} = $_tok;
                    push @item, $_tok;

                }

                $repcount++;

                my $savetext = $text;
                my $backtrack;

                # MATCH (OP RIGHTARG)(s)
                while ( $repcount < 100000000 ) {
                    $backtrack = 0;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [add_op]},
                        Parse::RecDescent::_tracefirst($text),
                        q{addition}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{add_op})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::add_op
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [add_op]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{addition},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [add_op]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{addition},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{add_op}} = $_tok;
                        push @item, $_tok;

                    }

                    $backtrack = 1;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [multiplication]},
                        Parse::RecDescent::_tracefirst($text),
                        q{addition}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{multiplication})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::multiplication
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [multiplication]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{addition},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
q{>>Matched subrule: [multiplication]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{addition},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{multiplication}} = $_tok;
                        push @item, $_tok;

                    }

                    $savetext = $text;
                    $repcount++;
                }
                $text = $savetext;
                pop @item if $backtrack;

                unless (@item) { undef $_tok; last }
                $_tok = [@item];
                last;
            }

            unless ( $repcount >= 1 ) {
                Parse::RecDescent::_trace(
q{<<Didn't match operator: [<leftop: multiplication add_op multiplication>]>>},
                    Parse::RecDescent::_tracefirst($text),
                    q{addition},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $expectation->failed();
                last;
            }
            Parse::RecDescent::_trace(
q{>>Matched operator: [<leftop: multiplication add_op multiplication>]<< (return value: [}
                  . qq{@{$_tok||[]}} . q{]},
                Parse::RecDescent::_tracefirst($text),
                q{addition},
                $tracelevel
              )
              if defined $::RD_TRACE;

            push @item, $item{__DIRECTIVE1__} = $_tok || [];

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{addition}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'addition '
                  if $Math::Symbolic::Parser::DEBUG;
                Math::Symbolic::Parser::_left_right_op_list( 'addition',
                    @item );
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
q{>>Matched production: [<leftop: multiplication add_op multiplication>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{addition},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{addition}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{addition}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{addition}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{addition},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::forced_unary_op
    {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"forced_unary_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [forced_unary_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{forced_unary_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [/([+-])/]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{forced_unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{forced_unary_op});
            %item = ( __RULE__ => q{forced_unary_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: [/([+-])/]},
                Parse::RecDescent::_tracefirst($text),
                q{forced_unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A(?:([+-]))// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace( q{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text) )
                  if defined $::RD_TRACE;

                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__PATTERN1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{forced_unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                $item[1];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [/([+-])/]<<},
                Parse::RecDescent::_tracefirst($text),
                q{forced_unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{forced_unary_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{forced_unary_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{forced_unary_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{forced_unary_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::expr {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"expr"};

        Parse::RecDescent::_trace(
            q{Trying rule: [expr]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{expr}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [addition]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{expr}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{expr});
            %item = ( __RULE__ => q{expr} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying subrule: [addition]},
                Parse::RecDescent::_tracefirst($text),
                q{expr}, $tracelevel
              )
              if defined $::RD_TRACE;
            if (1) {
                no strict qw{refs};
                $expectation->is(q{})->at($text);
                unless (
                    defined(
                        $_tok =
                          Parse::RecDescent::Math::Symbolic::Parser::Precompiled::addition
                          (
                            $thisparser, $text, $repeating,
                            $_noactions, sub    { \@arg }
                          )
                    )
                  )
                {

                    Parse::RecDescent::_trace(
                        q{<<Didn't match subrule: [addition]>>},
                        Parse::RecDescent::_tracefirst($text),
                        q{expr}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $expectation->failed();
                    last;
                }
                Parse::RecDescent::_trace(
                    q{>>Matched subrule: [addition]<< (return value: [} . $_tok
                      . q{]},

                    Parse::RecDescent::_tracefirst($text),
                    q{expr},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $item{q{addition}} = $_tok;
                push @item, $_tok;

            }

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{expr}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'expr ' if $Math::Symbolic::Parser::DEBUG;
                $item[1];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [addition]<<},
                Parse::RecDescent::_tracefirst($text),
                q{expr}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{expr}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{expr}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{expr}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{expr},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::function_name {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"function_name"};

        Parse::RecDescent::_trace(
            q{Trying rule: [function_name]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{function_name}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['log']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['log']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Alog// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['log']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['partial_derivative']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[1];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['partial_derivative']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Apartial_derivative// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['partial_derivative']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['total_derivative']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[2];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['total_derivative']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Atotal_derivative// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['total_derivative']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['sinh']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[3];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['sinh']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Asinh// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['sinh']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['cosh']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[4];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['cosh']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Acosh// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['cosh']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['asinh']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[5];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['asinh']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aasinh// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['asinh']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['acosh']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[6];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['acosh']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aacosh// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['acosh']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['asin']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[7];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['asin']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aasin// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['asin']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['acos']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[8];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['acos']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aacos// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['acos']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['atan']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[9];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['atan']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aatan// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['atan']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['acot']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[10];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['acot']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Aacot// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['acot']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['sin']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[11];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['sin']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Asin// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['sin']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['cos']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[12];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['cos']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Acos// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['cos']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['tan']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[13];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['tan']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Atan// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['tan']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: ['cot']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[14];
            $text = $_[1];
            my $_savetext;
            @item = (q{function_name});
            %item = ( __RULE__ => q{function_name} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: ['cot']},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\Acot// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: ['cot']<<},
                Parse::RecDescent::_tracefirst($text),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{function_name}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{function_name}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{function_name}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{function_name},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::list_op {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"list_op"};

        Parse::RecDescent::_trace(
            q{Trying rule: [list_op]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{list_op}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [',']},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{list_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{list_op});
            %item = ( __RULE__ => q{list_op} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: [',']},
                Parse::RecDescent::_tracefirst($text),
                q{list_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A\,// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace(
                    qq{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text)
                  )
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__STRING1__} = $&;

            Parse::RecDescent::_trace(
                q{>>Matched production: [',']<<},
                Parse::RecDescent::_tracefirst($text),
                q{list_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{list_op}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{list_op}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{list_op}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{list_op},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier_list
    {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"identifier_list"};

        Parse::RecDescent::_trace(
            q{Trying rule: [identifier_list]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{identifier_list}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [<leftop: identifier list_op identifier>]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{identifier_list},
                $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{identifier_list});
            %item = ( __RULE__ => q{identifier_list} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying operator: [<leftop: identifier list_op identifier>]},
                Parse::RecDescent::_tracefirst($text),
                q{identifier_list},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $expectation->is(q{})->at($text);

            $_tok = undef;
          OPLOOP: while (1) {
                $repcount = 0;
                my @item;

                # MATCH LEFTARG

                Parse::RecDescent::_trace(
                    q{Trying subrule: [identifier]},
                    Parse::RecDescent::_tracefirst($text),
                    q{identifier_list}, $tracelevel
                  )
                  if defined $::RD_TRACE;
                if (1) {
                    no strict qw{refs};
                    $expectation->is(q{identifier})->at($text);
                    unless (
                        defined(
                            $_tok =
                              Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier
                              (
                                $thisparser, $text, $repeating,
                                $_noactions, sub    { \@arg }
                              )
                        )
                      )
                    {

                        Parse::RecDescent::_trace(
                            q{<<Didn't match subrule: [identifier]>>},
                            Parse::RecDescent::_tracefirst($text),
                            q{identifier_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $expectation->failed();
                        last;
                    }
                    Parse::RecDescent::_trace(
                        q{>>Matched subrule: [identifier]<< (return value: [}
                          . $_tok . q{]},

                        Parse::RecDescent::_tracefirst($text),
                        q{identifier_list},
                        $tracelevel
                      )
                      if defined $::RD_TRACE;
                    $item{q{identifier}} = $_tok;
                    push @item, $_tok;

                }

                $repcount++;

                my $savetext = $text;
                my $backtrack;

                # MATCH (OP RIGHTARG)(s)
                while ( $repcount < 100000000 ) {
                    $backtrack = 0;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [list_op]},
                        Parse::RecDescent::_tracefirst($text),
                        q{identifier_list}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{list_op})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::list_op
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [list_op]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{identifier_list},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
                            q{>>Matched subrule: [list_op]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{identifier_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{list_op}} = $_tok;
                        push @item, $_tok;

                    }

                    $backtrack = 1;

                    Parse::RecDescent::_trace(
                        q{Trying subrule: [identifier]},
                        Parse::RecDescent::_tracefirst($text),
                        q{identifier_list}, $tracelevel
                      )
                      if defined $::RD_TRACE;
                    if (1) {
                        no strict qw{refs};
                        $expectation->is(q{identifier})->at($text);
                        unless (
                            defined(
                                $_tok =
                                  Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier
                                  (
                                    $thisparser, $text, $repeating,
                                    $_noactions, sub    { \@arg }
                                  )
                            )
                          )
                        {

                            Parse::RecDescent::_trace(
                                q{<<Didn't match subrule: [identifier]>>},
                                Parse::RecDescent::_tracefirst($text),
                                q{identifier_list},
                                $tracelevel
                              )
                              if defined $::RD_TRACE;
                            $expectation->failed();
                            last;
                        }
                        Parse::RecDescent::_trace(
q{>>Matched subrule: [identifier]<< (return value: [}
                              . $_tok . q{]},

                            Parse::RecDescent::_tracefirst($text),
                            q{identifier_list},
                            $tracelevel
                          )
                          if defined $::RD_TRACE;
                        $item{q{identifier}} = $_tok;
                        push @item, $_tok;

                    }

                    $savetext = $text;
                    $repcount++;
                }
                $text = $savetext;
                pop @item if $backtrack;

                unless (@item) { undef $_tok; last }
                $_tok = [@item];
                last;
            }

            unless ( $repcount >= 1 ) {
                Parse::RecDescent::_trace(
q{<<Didn't match operator: [<leftop: identifier list_op identifier>]>>},
                    Parse::RecDescent::_tracefirst($text),
                    q{identifier_list},
                    $tracelevel
                  )
                  if defined $::RD_TRACE;
                $expectation->failed();
                last;
            }
            Parse::RecDescent::_trace(
q{>>Matched operator: [<leftop: identifier list_op identifier>]<< (return value: [}
                  . qq{@{$_tok||[]}} . q{]},
                Parse::RecDescent::_tracefirst($text),
                q{identifier_list},
                $tracelevel
              )
              if defined $::RD_TRACE;

            push @item, $item{__DIRECTIVE1__} = $_tok || [];

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{identifier_list}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                warn 'identifier_list '
                  if $Math::Symbolic::Parser::DEBUG;
                my $i = 1;
                [ grep { $i == 1 ? ( --$i, 1 ) : ( ++$i, 0 ) } @{ $item[1] } ];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
q{>>Matched production: [<leftop: identifier list_op identifier>]<<},
                Parse::RecDescent::_tracefirst($text),
                q{identifier_list},
                $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{identifier_list}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{identifier_list}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{identifier_list}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{identifier_list},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }

    # ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args)
    sub Parse::RecDescent::Math::Symbolic::Parser::Precompiled::identifier {
        my $thisparser = $_[0];
        use vars q{$tracelevel};
        local $tracelevel = ( $tracelevel || 0 ) + 1;
        $ERRORS = 0;
        my $thisrule = $thisparser->{"rules"}{"identifier"};

        Parse::RecDescent::_trace(
            q{Trying rule: [identifier]},
            Parse::RecDescent::_tracefirst( $_[1] ),
            q{identifier}, $tracelevel
          )
          if defined $::RD_TRACE;

        my $err_at = @{ $thisparser->{errors} };

        my $score;
        my $score_return;
        my $_tok;
        my $return     = undef;
        my $_matched   = 0;
        my $commit     = 0;
        my @item       = ();
        my %item       = ();
        my $repeating  = defined( $_[2] ) && $_[2];
        my $_noactions = defined( $_[3] ) && $_[3];
        my @arg        = defined $_[4] ? @{ &{ $_[4] } } : ();
        my %arg        = ( $#arg & 01 ) ? @arg : ( @arg, undef );
        my $text;
        my $lastsep     = "";
        my $expectation =
          new Parse::RecDescent::Expectation( $thisrule->expected() );
        $expectation->at( $_[1] );

        my $thisline;
        tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

        while ( !$_matched && !$commit ) {

            Parse::RecDescent::_trace(
                q{Trying production: [/([a-zA-Z][a-zA-Z0-9_]*)/]},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{identifier}, $tracelevel
              )
              if defined $::RD_TRACE;
            my $thisprod = $thisrule->{"prods"}[0];
            $text = $_[1];
            my $_savetext;
            @item = (q{identifier});
            %item = ( __RULE__ => q{identifier} );
            my $repcount = 0;

            Parse::RecDescent::_trace(
                q{Trying terminal: [/([a-zA-Z][a-zA-Z0-9_]*)/]},
                Parse::RecDescent::_tracefirst($text),
                q{identifier}, $tracelevel
              )
              if defined $::RD_TRACE;
            $lastsep = "";
            $expectation->is(q{})->at($text);

            unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e
                and $text =~ s/\A(?:([a-zA-Z][a-zA-Z0-9_]*))// )
            {

                $expectation->failed();
                Parse::RecDescent::_trace( q{<<Didn't match terminal>>},
                    Parse::RecDescent::_tracefirst($text) )
                  if defined $::RD_TRACE;

                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched terminal<< (return value: [} . $& . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $item{__PATTERN1__} = $&;

            Parse::RecDescent::_trace(
                q{Trying action},
                Parse::RecDescent::_tracefirst($text),
                q{identifier}, $tracelevel
              )
              if defined $::RD_TRACE;

            $_tok = ($_noactions) ? 0 : do {
                $item[1];
            };
            unless ( defined $_tok ) {
                Parse::RecDescent::_trace(
                    q{<<Didn't match action>> (return value: [undef])})
                  if defined $::RD_TRACE;
                last;
            }
            Parse::RecDescent::_trace(
                q{>>Matched action<< (return value: [} . $_tok . q{])},
                Parse::RecDescent::_tracefirst($text) )
              if defined $::RD_TRACE;
            push @item, $_tok;
            $item{__ACTION1__} = $_tok;

            Parse::RecDescent::_trace(
                q{>>Matched production: [/([a-zA-Z][a-zA-Z0-9_]*)/]<<},
                Parse::RecDescent::_tracefirst($text),
                q{identifier}, $tracelevel
              )
              if defined $::RD_TRACE;
            $_matched = 1;
            last;
        }

        unless ( $_matched || defined($return) || defined($score) ) {

            $_[1] = $text;    # NOT SURE THIS IS NEEDED
            Parse::RecDescent::_trace(
                q{<<Didn't match rule>>},
                Parse::RecDescent::_tracefirst( $_[1] ),
                q{identifier}, $tracelevel
              )
              if defined $::RD_TRACE;
            return undef;
        }
        if ( !defined($return) && defined($score) ) {
            Parse::RecDescent::_trace( q{>>Accepted scored production<<},
                "", q{identifier}, $tracelevel )
              if defined $::RD_TRACE;
            $return = $score_return;
        }
        splice @{ $thisparser->{errors} }, $err_at;
        $return = $item[$#item] unless defined $return;
        if ( defined $::RD_TRACE ) {
            Parse::RecDescent::_trace(
                q{>>Matched rule<< (return value: [} . $return . q{])},
                "", q{identifier}, $tracelevel );
            Parse::RecDescent::_trace(
                q{(consumed: [}
                  . Parse::RecDescent::_tracemax(
                    substr( $_[1], 0, -length($text) )
                  )
                  . q{])},
                Parse::RecDescent::_tracefirst($text),
                ,
                q{identifier},
                $tracelevel
            );
        }
        $_[1] = $text;
        return $return;
    }
}

package Math::Symbolic::Parser::Precompiled;

sub new {
    my $self = bless(
        {
            '_AUTOTREE' => undef,
            'rules'     => {
                'parse' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '1',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '1',
                                                'subrule'   => 'expr',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => 0,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 1,
                                    'error'    => 1,
                                    'line'     => '2',
                                    'items'    => [
                                        bless(
                                            {
                                                'line'       => '2',
                                                'commitonly' => '',
                                                'hashname'  => '__DIRECTIVE1__',
                                                'lookahead' => 0,
                                                'msg'       => ''
                                            },
                                            'Parse::RecDescent::Error'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [ 'expr' ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'parse'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'expr_list' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '177',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => undef,
                                    'op'       => [],
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'min' => 1,
                                                'op'  => bless(
                                                    {
                                                        'line'     => '177',
                                                        'subrule'  => 'list_op',
                                                        'argcode'  => undef,
                                                        'implicit' => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'hashname' => '__DIRECTIVE1__',
                                                'leftarg'  => bless(
                                                    {
                                                        'line'      => '177',
                                                        'subrule'   => 'expr',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'name'     => '',
                                                'rightarg' => bless(
                                                    {
                                                        'line'      => '177',
                                                        'subrule'   => 'expr',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'expected' =>
                                                  '<leftop: expr list_op expr>',
                                                'max'  => 100000000,
                                                'type' => 'leftop'
                                            },
                                            'Parse::RecDescent::Operator'
                                        ),
                                        bless(
                                            {
                                                'line' => '178',
                                                'code' => '{
				warn \'expr_list \'
				  if $Math::Symbolic::Parser::DEBUG;
				my $i = 1;
				[
					grep {
						$i==1 ?
						(--$i, 1) :
						(++$i, 0)
					}
					@{$item[1]}
				]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'expr',
                            'list_op'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'expr_list'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'number' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '134',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 1,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' =>
                                                  '/\\\\d+(\\\\.\\\\d+)?/',
                                                'pattern'   => '\\d+(\\.\\d+)?',
                                                'mod'       => '',
                                                'hashname'  => '__PATTERN1__',
                                                'lookahead' => 0,
                                                'ldelim'    => '/',
                                                'line'      => '134',
                                                'rdelim'    => '/'
                                            },
                                            'Parse::RecDescent::Token'
                                        ),
                                        bless(
                                            {
                                                'line' => '135',
                                                'code' => '{
				warn \'number \'
				  if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Constant->new($item[1])
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'number'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'add_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '19',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'+\'',
                                                'line'        => '19',
                                                'pattern'     => '+',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '20',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'-\'',
                                                'line'        => '20',
                                                'pattern'     => '-',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'add_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'mult_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '31',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'*\'',
                                                'line'        => '31',
                                                'pattern'     => '*',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '32',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'/\'',
                                                'line'        => '32',
                                                'pattern'     => '/',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'mult_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'variable' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '194',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 2,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '194',
                                                'subrule'   => 'identifier',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'description' => '\'(\'',
                                                'line'        => '194',
                                                'pattern'     => '(',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line'     => '194',
                                                'subrule'  => 'identifier_list',
                                                'argcode'  => undef,
                                                'implicit' => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'description' => '\')\'',
                                                'line'        => '194',
                                                'pattern'     => ')',
                                                'hashname'    => '__STRING2__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line' => '195',
                                                'code' => '{
				warn \'variable \'
				  if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Variable->new(
				  {
				    name => $item[1],
				    signature => $item[3],
				  }
				);
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '206',
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '206',
                                                'subrule'   => 'identifier',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '207',
                                                'code' => '{
				warn \'variable \'
				  if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Variable->new(
				  {
				    name => $item[1],
				  }
				);
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'identifier',
                            'identifier_list'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'variable'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'unary' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '58',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'     => '58',
                                                'subrule'  => 'forced_unary_op',
                                                'argcode'  => undef,
                                                'implicit' => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line'      => '58',
                                                'subrule'   => 'factor',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '59',
                                                'code' => '{
				warn \'unary \'
				  if $Math::Symbolic::Parser::DEBUG;
				if ($item[1] and $item[1] eq \'-\') {
					Math::Symbolic::Operator->new(
					  {
					    type => Math::Symbolic::U_MINUS,
					    operands => [$item[2]],
					  }
					);
				}
				else {
					$item[2]
				}
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '75',
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '75',
                                                'subrule'   => 'unary_op',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line'      => '75',
                                                'subrule'   => 'number',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '76',
                                                'code' => '{
				warn \'unary \'
				  if $Math::Symbolic::Parser::DEBUG;
				if ($item[1] and $item[1] eq \'-\') {
					Math::Symbolic::Operator->new(
					  {
					    type => Math::Symbolic::U_MINUS,
					    operands => [$item[2]],
					  }
					);
				}
				else {
					$item[2]
				}
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 2,
                                    'error'    => undef,
                                    'line'     => '91',
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '91',
                                                'subrule'   => 'unary_op',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line'      => '91',
                                                'subrule'   => 'function',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '92',
                                                'code' => '{
				warn \'unary \'
				  if $Math::Symbolic::Parser::DEBUG;
				if ($item[1] and $item[1] eq \'-\') {
					Math::Symbolic::Operator->new(
					  {
					    type => Math::Symbolic::U_MINUS,
					    operands => [$item[2]],
					  }
					);
				}
				else {
					$item[2]
				}
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 3,
                                    'error'    => undef,
                                    'line'     => '107',
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '107',
                                                'subrule'   => 'unary_op',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line'      => '107',
                                                'subrule'   => 'variable',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '108',
                                                'code' => '{
				warn \'unary \'
				  if $Math::Symbolic::Parser::DEBUG;
				if ($item[1] and $item[1] eq \'-\') {
					Math::Symbolic::Operator->new(
					  {
					    type => Math::Symbolic::U_MINUS,
					    operands => [$item[2]],
					  }
					);
				}
				else {
					$item[2]
				}
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'forced_unary_op',
                            'factor',
                            'unary_op',
                            'number',
                            'function',
                            'variable'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'unary'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'factor' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '45',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '45',
                                                'subrule'   => 'unary',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '46',
                                                'code' => '{
				warn \'factor \'
				  if $Math::Symolic::Parser::DEBUG;
				$item[1]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 2,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '51',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'(\'',
                                                'line'        => '51',
                                                'pattern'     => '(',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line'      => '51',
                                                'subrule'   => 'expr',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'description' => '\')\'',
                                                'line'        => '51',
                                                'pattern'     => ')',
                                                'hashname'    => '__STRING2__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line' => '52',
                                                'code' => '{
				warn \'factor \'
					if $Math::Symbolic::Parser::DEBUG;
				$item[2]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'unary',
                            'expr'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'factor'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'unary_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '124',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 1,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '/([+-]?)/',
                                                'pattern'     => '([+-]?)',
                                                'mod'         => '',
                                                'hashname'    => '__PATTERN1__',
                                                'lookahead'   => 0,
                                                'ldelim'      => '/',
                                                'line'        => '124',
                                                'rdelim'      => '/'
                                            },
                                            'Parse::RecDescent::Token'
                                        ),
                                        bless(
                                            {
                                                'line' => '125',
                                                'code' => '{
				$item[1]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'unary_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'exp_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '43',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'^\'',
                                                'line'        => '43',
                                                'pattern'     => '^',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'exp_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'function' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '141',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 2,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '141',
                                                'subrule'   => 'function_name',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'description' => '\'(\'',
                                                'line'        => '141',
                                                'pattern'     => '(',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line'      => '141',
                                                'subrule'   => 'expr_list',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'description' => '\')\'',
                                                'line'        => '141',
                                                'pattern'     => ')',
                                                'hashname'    => '__STRING2__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        ),
                                        bless(
                                            {
                                                'line' => '142',
                                                'code' => '{
				warn \'function \' 
				  if $Math::Symbolic::Parser::DEBUG;
				my $function =
				  $Math::Symbolic::Operator::Op_Symbols{
				    $item[1]
				  };
				die "Invalid function \'$item[1]\'!"
				  unless defined $function;
					
				Math::Symbolic::Operator->new(
				  {
				    type => $function,
				    operands => $item[3],
				  }
				);
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'function_name',
                            'expr_list'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'function'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'exp' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '35',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => undef,
                                    'op'       => [],
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'min' => 1,
                                                'op'  => bless(
                                                    {
                                                        'line'      => '35',
                                                        'subrule'   => 'exp_op',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'hashname' => '__DIRECTIVE1__',
                                                'leftarg'  => bless(
                                                    {
                                                        'line'      => '35',
                                                        'subrule'   => 'factor',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'name'     => '',
                                                'rightarg' => bless(
                                                    {
                                                        'line'      => '35',
                                                        'subrule'   => 'factor',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'expected' =>
'<rightop: factor exp_op factor>',
                                                'max'  => 100000000,
                                                'type' => 'rightop'
                                            },
                                            'Parse::RecDescent::Operator'
                                        ),
                                        bless(
                                            {
                                                'line' => '36',
                                                'code' => '{
				warn \'exp \' if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Parser::_left_right_op_list(
				  \'exp\', @item
				)
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'factor',
                            'exp_op'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'exp'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'multiplication' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '22',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => undef,
                                    'op'       => [],
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'min' => 1,
                                                'op'  => bless(
                                                    {
                                                        'line'     => '22',
                                                        'subrule'  => 'mult_op',
                                                        'argcode'  => undef,
                                                        'implicit' => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'hashname' => '__DIRECTIVE1__',
                                                'leftarg'  => bless(
                                                    {
                                                        'line'      => '22',
                                                        'subrule'   => 'exp',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'name'     => '',
                                                'rightarg' => bless(
                                                    {
                                                        'line'      => '22',
                                                        'subrule'   => 'exp',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'expected' =>
                                                  '<leftop: exp mult_op exp>',
                                                'max'  => 100000000,
                                                'type' => 'leftop'
                                            },
                                            'Parse::RecDescent::Operator'
                                        ),
                                        bless(
                                            {
                                                'line' => '23',
                                                'code' => '{
				warn \'multiplication \'
				  if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Parser::_left_right_op_list(
				  \'multiplication\', @item
				)
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'exp',
                            'mult_op'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'multiplication'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'addition' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '10',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => undef,
                                    'op'       => [],
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'min' => 1,
                                                'op'  => bless(
                                                    {
                                                        'line'      => '10',
                                                        'subrule'   => 'add_op',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'hashname' => '__DIRECTIVE1__',
                                                'leftarg'  => bless(
                                                    {
                                                        'line'    => '10',
                                                        'subrule' =>
                                                          'multiplication',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'name'     => '',
                                                'rightarg' => bless(
                                                    {
                                                        'line'    => '10',
                                                        'subrule' =>
                                                          'multiplication',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'expected' =>
'<leftop: multiplication add_op multiplication>',
                                                'max'  => 100000000,
                                                'type' => 'leftop'
                                            },
                                            'Parse::RecDescent::Operator'
                                        ),
                                        bless(
                                            {
                                                'line' => '11',
                                                'code' => '{
				warn \'addition \'
				  if $Math::Symbolic::Parser::DEBUG;
				Math::Symbolic::Parser::_left_right_op_list(
				  \'addition\', @item
				)
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'multiplication',
                            'add_op'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'addition'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'forced_unary_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '129',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 1,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '/([+-])/',
                                                'pattern'     => '([+-])',
                                                'mod'         => '',
                                                'hashname'    => '__PATTERN1__',
                                                'lookahead'   => 0,
                                                'ldelim'      => '/',
                                                'line'        => '129',
                                                'rdelim'      => '/'
                                            },
                                            'Parse::RecDescent::Token'
                                        ),
                                        bless(
                                            {
                                                'line' => '130',
                                                'code' => '{
				$item[1]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'forced_unary_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'expr' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '4',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'line'      => '4',
                                                'subrule'   => 'addition',
                                                'argcode'   => undef,
                                                'implicit'  => undef,
                                                'matchrule' => 0,
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Subrule'
                                        ),
                                        bless(
                                            {
                                                'line' => '5',
                                                'code' => '{
				warn \'expr \' if $Math::Symbolic::Parser::DEBUG;
				$item[1]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [ 'addition' ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'expr'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'function_name' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '160',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'log\'',
                                                'line'        => '160',
                                                'pattern'     => 'log',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 1,
                                    'error'    => undef,
                                    'line'     => '161',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' =>
                                                  '\'partial_derivative\'',
                                                'line'    => '161',
                                                'pattern' =>
                                                  'partial_derivative',
                                                'hashname'  => '__STRING1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 2,
                                    'error'    => undef,
                                    'line'     => '162',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' =>
                                                  '\'total_derivative\'',
                                                'line'    => '162',
                                                'pattern' => 'total_derivative',
                                                'hashname'  => '__STRING1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 3,
                                    'error'    => undef,
                                    'line'     => '163',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'sinh\'',
                                                'line'        => '163',
                                                'pattern'     => 'sinh',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 4,
                                    'error'    => undef,
                                    'line'     => '164',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'cosh\'',
                                                'line'        => '164',
                                                'pattern'     => 'cosh',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 5,
                                    'error'    => undef,
                                    'line'     => '165',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'asinh\'',
                                                'line'        => '165',
                                                'pattern'     => 'asinh',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 6,
                                    'error'    => undef,
                                    'line'     => '166',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'acosh\'',
                                                'line'        => '166',
                                                'pattern'     => 'acosh',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 7,
                                    'error'    => undef,
                                    'line'     => '167',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'asin\'',
                                                'line'        => '167',
                                                'pattern'     => 'asin',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 8,
                                    'error'    => undef,
                                    'line'     => '168',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'acos\'',
                                                'line'        => '168',
                                                'pattern'     => 'acos',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 9,
                                    'error'    => undef,
                                    'line'     => '169',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'atan\'',
                                                'line'        => '169',
                                                'pattern'     => 'atan',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 10,
                                    'error'    => undef,
                                    'line'     => '170',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'acot\'',
                                                'line'        => '170',
                                                'pattern'     => 'acot',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 11,
                                    'error'    => undef,
                                    'line'     => '171',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'sin\'',
                                                'line'        => '171',
                                                'pattern'     => 'sin',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 12,
                                    'error'    => undef,
                                    'line'     => '172',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'cos\'',
                                                'line'        => '172',
                                                'pattern'     => 'cos',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 13,
                                    'error'    => undef,
                                    'line'     => '173',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'tan\'',
                                                'line'        => '173',
                                                'pattern'     => 'tan',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            ),
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 14,
                                    'error'    => undef,
                                    'line'     => '174',
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\'cot\'',
                                                'line'        => '174',
                                                'pattern'     => 'cot',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'function_name'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'list_op' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '192',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 0,
                                    'strcount' => 1,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' => '\',\'',
                                                'line'        => '192',
                                                'pattern'     => ',',
                                                'hashname'    => '__STRING1__',
                                                'lookahead'   => 0
                                            },
                                            'Parse::RecDescent::Literal'
                                        )
                                    ],
                                    'actcount' => 0
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'list_op'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'identifier_list' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '222',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 1,
                                    'uncommit' => undef,
                                    'op'       => [],
                                    'patcount' => 0,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'min' => 1,
                                                'op'  => bless(
                                                    {
                                                        'line'     => '222',
                                                        'subrule'  => 'list_op',
                                                        'argcode'  => undef,
                                                        'implicit' => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'hashname' => '__DIRECTIVE1__',
                                                'leftarg'  => bless(
                                                    {
                                                        'line'    => '222',
                                                        'subrule' =>
                                                          'identifier',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'name'     => '',
                                                'rightarg' => bless(
                                                    {
                                                        'line'    => '222',
                                                        'subrule' =>
                                                          'identifier',
                                                        'argcode'   => undef,
                                                        'implicit'  => undef,
                                                        'matchrule' => 0,
                                                        'lookahead' => 0
                                                    },
                                                    'Parse::RecDescent::Subrule'
                                                ),
                                                'expected' =>
'<leftop: identifier list_op identifier>',
                                                'max'  => 100000000,
                                                'type' => 'leftop'
                                            },
                                            'Parse::RecDescent::Operator'
                                        ),
                                        bless(
                                            {
                                                'line' => '223',
                                                'code' => '{
				warn \'identifier_list \'
				  if $Math::Symbolic::Parser::DEBUG;
				my $i = 1;
				[
					grep {
						$i==1 ?
						(--$i, 1) :
						(++$i, 0)
					}
					@{$item[1]}
				]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls' => [
                            'identifier',
                            'list_op'
                        ],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'identifier_list'
                    },
                    'Parse::RecDescent::Rule'
                ),
                'identifier' => bless(
                    {
                        'impcount' => 0,
                        'line'     => '217',
                        'prods'    => [
                            bless(
                                {
                                    'dircount' => 0,
                                    'uncommit' => undef,
                                    'patcount' => 1,
                                    'strcount' => 0,
                                    'number'   => 0,
                                    'error'    => undef,
                                    'line'     => undef,
                                    'items'    => [
                                        bless(
                                            {
                                                'description' =>
                                                  '/([a-zA-Z][a-zA-Z0-9_]*)/',
                                                'pattern' =>
                                                  '([a-zA-Z][a-zA-Z0-9_]*)',
                                                'mod'       => '',
                                                'hashname'  => '__PATTERN1__',
                                                'lookahead' => 0,
                                                'ldelim'    => '/',
                                                'line'      => '217',
                                                'rdelim'    => '/'
                                            },
                                            'Parse::RecDescent::Token'
                                        ),
                                        bless(
                                            {
                                                'line' => '218',
                                                'code' => '{
				$item[1]
			}',
                                                'hashname'  => '__ACTION1__',
                                                'lookahead' => 0
                                            },
                                            'Parse::RecDescent::Action'
                                        )
                                    ],
                                    'actcount' => 1
                                },
                                'Parse::RecDescent::Production'
                            )
                        ],
                        'calls'   => [],
                        'opcount' => 0,
                        'changed' => 0,
                        'vars'    => '',
                        'name'    => 'identifier'
                    },
                    'Parse::RecDescent::Rule'
                )
            },
            'namespace' =>
              'Parse::RecDescent::Math::Symbolic::Parser::Precompiled',
            '_check' => {
                'prevline'   => '',
                'prevcolumn' => '',
                'thiscolumn' => '',
                'prevoffset' => '',
                'thisoffset' => '',
                'itempos'    => ''
            },
            '_AUTOACTION' => undef,
            'localvars'   => '',
            'startcode'   => ''
        },
        'Parse::RecDescent'
    );
}
