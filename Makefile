
all:
	bash build.sh

clean:
	rm -rf tmp/*
	rm -rf vc/*
	rm -rf mingw/*
	rm -rf ios/*
	rm -rf tvos/*
	rm -rf wasm/*

# Remove Xcode user data:
#   find ./xcode -name "xcuserdata" -type d -exec rm -r "{}" \;
