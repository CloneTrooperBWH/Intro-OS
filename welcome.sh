name=$*
if [[ "$name" =~ ^[A-Za-z0-9_\ ]{3,16}$ ]]; then
	echo "Welcome, $name!"
	exit 0
else
	echo "Invalid nickname" >&2
	exit 1
fi
