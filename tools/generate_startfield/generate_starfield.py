import random

from PIL import Image, ImageDraw

WIDTH = 2048
HEIGHT = 1024

BACKGROUND = (2, 3, 8)

DIM_STARS = 2500
MEDIUM_STARS = 500
BRIGHT_STARS = 80

OUTPUT_FILE = "starfield.png"


def random_star_color():
    choices = [
        (255, 255, 255),
        (220, 230, 255),
        (255, 240, 210),
        (200, 210, 230),
    ]

    return random.choice(choices)


def main():
    image = Image.new("RGB", (WIDTH, HEIGHT), BACKGROUND)
    draw = ImageDraw.Draw(image)

    # Lots of tiny dim stars.
    for _ in range(DIM_STARS):
        x = random.randrange(WIDTH)
        y = random.randrange(HEIGHT)

        brightness = random.randint(90, 170)

        draw.point(
            (x, y),
            fill=(brightness, brightness, brightness),
        )

    # Fewer brighter stars.
    for _ in range(MEDIUM_STARS):
        x = random.randrange(WIDTH)
        y = random.randrange(HEIGHT)

        color = random_star_color()

        draw.point((x, y), fill=color)

    # A small number of larger bright stars.
    for _ in range(BRIGHT_STARS):
        x = random.randrange(WIDTH)
        y = random.randrange(HEIGHT)

        color = random_star_color()

        draw.ellipse(
            (
                x - 1,
                y - 1,
                x + 1,
                y + 1,
            ),
            fill=color,
        )

    image.save(OUTPUT_FILE)

    print(f"Generated {OUTPUT_FILE}")


if __name__ == "__main__":
    main()