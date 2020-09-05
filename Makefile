
.PHONY: setup
setup:
	go mod vendor
	git clone https://github.com/therecipe/env_darwin_amd64_513.git vendor/github.com/therecipe/env_darwin_amd64_513
	qtsetup
	
mod:
	mkdir _temp
	mv vendor/github.com/therecipe/qt _temp/qt
	mv vendor/github.com/therecipe/env_darwin_amd64_513 _temp/env_darwin_amd64_513
	go mod vendor
	mv _temp/env_darwin_amd64_513 vendor/github.com/therecipe/env_darwin_amd64_513
	mv _temp/qt vendor/github.com/therecipe/qt
	rm -rf _temp

clean-moc:
	find ./internal -name 'moc*' -delete

clean:
	rm rcc.cpp rcc.qrc rcc_cgo_darwin_darwin_amd64.go rcc_cgo_linux_linux_amd64.go

define make_icns
	mkdir _temp.iconset
	sips -z 16 16 $(1) --out _temp.iconset/icon_16x16.png
	sips -z 32 32 $(1) --out _temp.iconset/icon_16x16@2x.png
	sips -z 32 32 $(1) --out _temp.iconset/icon_32x32.png
	sips -z 64 64 $(1) --out _temp.iconset/icon_32x32@2x.png
	sips -z 128 128 $(1) --out _temp.iconset/icon_128x128.png
	sips -z 256 256 $(1) --out _temp.iconset/icon_128x128@2x.png
	sips -z 256 256 $(1) --out _temp.iconset/icon_256x256.png
	sips -z 512 512 $(1) --out _temp.iconset/icon_256x256@2x.png
	sips -z 512 512 $(1) --out _temp.iconset/icon_512x512.png
	sips -z 1024 1024 $(1) --out _temp.iconset/icon_512x512@2x.png
	iconutil -c icns -o $(2) _temp.iconset
	rm -rf _temp.iconset
endef

.PHONY: darwin-icon
IN=wombat_512@2x.png
OUT=darwin/wombat.iconset
darwin-icon:
	$(call make_icns, wombar_512@2x.png, darwin/Content/Resources/Wombat.icns)

.PHONY: win-icon
IN=wombat_512@2x.png
# OUT=windows/iconset
win-icon:
	mkdir -p $(OUT)
	sips -z 16 16 $(IN) --out $(OUT)/icon_16.png
	sips -z 24 24 $(IN) --out $(OUT)/icon_24.png
	sips -z 32 32 $(IN) --out $(OUT)/icon_32.png
	sips -z 48 48 $(IN) --out $(OUT)/icon_48.png
	sips -z 64 64 $(IN) --out $(OUT)/icon_64.png
	sips -z 128 128 $(IN) --out $(OUT)/icon_128.png
	png2ico windows/icon.ico $(OUT)/icon_16.png $(OUT)/icon_24.png $(OUT)/icon_32.png $(OUT)/icon_48.png $(OUT)/icon_64.png $(OUT)/icon_128.png
	rm -rf $(OUT)
	rsrc -ico windows/icon.ico -o icon.syso -arch=amd64

dmg-icon:
	$(call make_icns, assets/darwin/dmg_icon.png, assets/darwin/dmg_icon.icns)

dmg:
	-rm Wombat.dmg	
	create-dmg \
		--volname "Wombat" \
		--volicon "assets/darwin/dmg_icon.icns" \
		--background "assets/darwin/dmg_bg.png" \
		--window-size 512 360 \
		--icon-size 100 \
		--icon "Wombat.app" 100 185 \
		--hide-extension "Wombat.app" \
		--app-drop-link 388 185 \
		"Wombat.dmg" \
		"deploy/darwin"
