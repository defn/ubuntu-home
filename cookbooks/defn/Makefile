all: berks style

berks:
	berks update
	berks install

style:
	foodcritic .
	rubocop .
