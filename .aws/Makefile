all:
	true

unlock:
	gpg --batch --yes --decrypt --output credentials credentials.gpg

lock:
	gpg --batch --yes --encrypt --output credentials.gpg --armor credentials

