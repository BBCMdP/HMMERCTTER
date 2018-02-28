function Text = fn_subtext_cFetching(FileGroup,FileSeq,OutputFileName)
% #!/usr/bin/perl
% no warnings "all";
% 
% use Bio::Perl;
% use Bio::SeqIO;
% use IO::String;
% use Bio::SearchIO;
% use Bio::AlignIO::clustalw;
% use Bio::SimpleAlign; 
% use Storable;
% use Bio::Location::Simple;
% use Bio::Location::FuzzyLocationI;
% use Bio::Align::AlignI;
% use Bio::LocatableSeq;
% use Bio::Root::Root;
% use File::Slurp;


Text = {};
Posi = 0;
Posi = Posi + 1; Text{Posi} = '#!/usr/bin/perl';
Posi = Posi + 1; Text{Posi} = '';

Posi = Posi + 1; Text{Posi} = 'use strict;';
Posi = Posi + 1; Text{Posi} = 'use Bio::DB::Fasta;';

Posi = Posi + 1; Text{Posi} = 'my $database;';
Posi = Posi + 1; Text{Posi} = 'my $fasta_library;';
Posi = Posi + 1; Text{Posi} = 'my %records;';
Posi = Posi + 1; Text{Posi} = ['open IDFILE, "' FileGroup '" or die $!;'];
Posi = Posi + 1; Text{Posi} = ['open OUTPUT, ">fetching_' OutputFileName '" or die$!;'];

Posi = Posi + 1; Text{Posi} = '#  name of the library file - (here it is hardcoded)';
Posi = Posi + 1; Text{Posi} = ['$fasta_library=''' FileSeq ''';'];

Posi = Posi + 1; Text{Posi} =  '# creates the database of the library, based on the file';
Posi = Posi + 1; Text{Posi} = '$database = Bio::DB::Fasta->new("$fasta_library") or die "Failed to creat Fasta DP object on fasta library\n";';


Posi = Posi + 1; Text{Posi} = '# now, it parses the file with the fasta headers you want to get';
Posi = Posi + 1; Text{Posi} = 'while (<IDFILE>) {';

Posi = Posi + 1; Text{Posi} =  '     my ($id) = (/^>*(\S+)/);  # capture the id string (without the initial ">")';
Posi = Posi + 1; Text{Posi} =  '     my $header = $database->header($id);';
Posi = Posi + 1; Text{Posi} =  '    print OUTPUT  ">$header\n", $database->seq( $id ), "\n";';
Posi = Posi + 1; Text{Posi} = '}';

Posi = Posi + 1; Text{Posi} = 'exit;';

return



