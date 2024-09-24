# Example usage: make COLOR="#83a598"

.PHONY: all clean

colorized: _shroomish.png colorized.png mask.png
	magick _shroomish.png colorized.png mask.png -composite shroomish.png

colorized.png: _shroomish.png
	magick $< -fill "$(COLOR)" -colorspace HSL -colorize 100%,0,0 $@


tinted: _shroomish.png tinted.png mask.png
	magick _shroomish.png tinted.png mask.png -composite shroomish.png

tinted.png: grayscale.png
	magick $< -fill "$(COLOR)" -tint 100% $@

grayscale.png: _shroomish.png
	magick $< -colorspace HSL -channel 2 -separate $@

mask.png: _shroomish.png
	magick $< -colorspace HSL -channel 0 -threshold 20% -separate $@

clean:
	rm -f colorized.png tinted.png grayscale.png mask.png shroomish.png
