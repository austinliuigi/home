import manim
from .palette import palette
from .basic_palette import basic_palette

PALETTE = basic_palette
# PALETTE = palette

p = {k: manim.ManimColor(v) for k, v in PALETTE.items()}


def init_palette():
    # ============================================================================
    # OVERRIDE BULITIN COLORS
    # ============================================================================

    manim.BLACK = p["base00"]
    manim.WHITE = p["base05"]

    manim.GRAY_A = p["base01"]
    manim.GREY_A = p["base01"]
    manim.GRAY_B = p["base02"]
    manim.GREY_B = p["base02"]
    manim.GRAY_C = p["base03"]
    manim.GREY_C = p["base03"]
    manim.GRAY_D = p["base03"]
    manim.GREY_D = p["base03"]
    manim.GRAY_E = p["base04"]
    manim.GREY_E = p["base04"]

    manim.LIGHTER_GRAY = manim.GRAY_A
    manim.LIGHTER_GREY = manim.GREY_A
    manim.LIGHT_GRAY = manim.GRAY_B
    manim.LIGHT_GREY = manim.GRAY_B
    manim.GRAY = manim.GRAY_C
    manim.GREY = manim.GREY_C
    manim.DARK_GRAY = manim.GRAY_D
    manim.DARK_GREY = manim.GREY_D
    manim.DARKER_GRAY = manim.GRAY_E
    manim.DARKER_GREY = manim.GREY_E

    manim.RED_A = p["red"].lighter(0.2)
    manim.RED_B = p["red"].lighter(0.1)
    manim.RED_C = p["red"]
    manim.RED_D = p["red"].darker(0.1)
    manim.RED_E = p["red"].darker(0.2)
    manim.RED = p["red"]

    manim.GOLD_A = p["orange"].lighter(0.2)
    manim.GOLD_B = p["orange"].lighter(0.1)
    manim.GOLD_C = p["orange"]
    manim.GOLD_D = p["orange"].darker(0.1)
    manim.GOLD_E = p["orange"].darker(0.2)
    manim.GOLD = p["orange"]

    manim.YELLOW_A = p["yellow"].lighter(0.2)
    manim.YELLOW_B = p["yellow"].lighter(0.1)
    manim.YELLOW_C = p["yellow"]
    manim.YELLOW_D = p["yellow"].darker(0.1)
    manim.YELLOW_E = p["yellow"].darker(0.2)
    manim.YELLOW = p["yellow"]

    manim.GREEN_A = p["green"].lighter(0.2)
    manim.GREEN_B = p["green"].lighter(0.1)
    manim.GREEN_C = p["green"]
    manim.GREEN_D = p["green"].darker(0.1)
    manim.GREEN_E = p["green"].darker(0.2)
    manim.GREEN = p["green"]

    manim.TEAL_A = p["cyan"].lighter(0.2)
    manim.TEAL_B = p["cyan"].lighter(0.1)
    manim.TEAL_C = p["cyan"]
    manim.TEAL_D = p["cyan"].darker(0.1)
    manim.TEAL_E = p["cyan"].darker(0.2)
    manim.TEAL = p["cyan"]

    manim.BLUE_A = p["blue"].lighter(0.2)
    manim.BLUE_B = p["blue"].lighter(0.1)
    manim.BLUE_C = p["blue"]
    manim.BLUE_D = p["blue"].darker(0.1)
    manim.BLUE_E = p["blue"].darker(0.2)
    manim.BLUE = p["blue"]

    manim.PURPLE_A = p["purple"].lighter(0.2)
    manim.PURPLE_B = p["purple"].lighter(0.1)
    manim.PURPLE_C = p["purple"]
    manim.PURPLE_D = p["purple"].darker(0.1)
    manim.PURPLE_E = p["purple"].darker(0.2)
    manim.PURPLE = p["purple"]

    manim.MAROON_A = p["red"].lighter(0.2)
    manim.MAROON_B = p["red"].lighter(0.1)
    manim.MAROON_C = p["red"]
    manim.MAROON_D = p["red"].darker(0.1)
    manim.MAROON_E = p["red"].darker(0.2)
    manim.MAROON = p["red"]

    manim.PINK = 0.5 * manim.RED + 0.5 * manim.WHITE
    manim.LIGHT_PINK = manim.PINK.lighter(0.2)

    manim.ORANGE = p["orange"]
    manim.LIGHT_BROWN = p["brown"]
    manim.DARK_BROWN = manim.LIGHT_BROWN.darker(0.1)
    manim.GRAY_BROWN = 0.5 * manim.LIGHT_BROWN + 0.5 * manim.GRAY
    manim.GREY_BROWN = 0.5 * manim.LIGHT_BROWN + 0.5 * manim.GREY

    # ============================================================================
    # OVERRIDE DEFAULT COLORS
    # ============================================================================

    # ----------------------------------------------------------------------------
    # BACKGROUND
    # ----------------------------------------------------------------------------
    # manim.Scene.camera.background_color = p["bg"]
    manim.config.background_color = manim.BLACK

    # ----------------------------------------------------------------------------
    # MOBJECTS
    # ----------------------------------------------------------------------------
    manim.Mobject.set_default(color=manim.WHITE)
    manim.VMobject.set_default(color=manim.WHITE)

    manim.Rectangle.set_default(color=manim.WHITE)
    manim.AnnotationDot.set_default(stroke_color=manim.WHITE, fill_color=manim.BLUE)
    manim.Arc.set_default(stroke_color=manim.WHITE)
    manim.AnnularSector.set_default(color=manim.WHITE)

    manim.Angle.set_default(color=manim.WHITE)
    manim.AnnotationDot.set_default(stroke_color=manim.WHITE)
    manim.Annulus.set_default(color=manim.WHITE)
    manim.Arrow.set_default(color=manim.WHITE)
    manim.Arrow3D.set_default(color=manim.WHITE)
    manim.ArrowVectorField.set_default(color=manim.WHITE)
    manim.Code.set_default(font="Courier New", color=manim.WHITE)
    manim.CubicBezier.set_default(color=manim.WHITE)
    manim.DashedVMobject.set_default(color=manim.WHITE)
    manim.Dot.set_default(color=manim.WHITE)
    manim.Dot3D.set_default(color=manim.WHITE)
    manim.Line.set_default(color=manim.WHITE)
    manim.Line3D.set_default(color=manim.WHITE)
    manim.MarkupText.set_default(color=manim.WHITE)
    manim.Polygon.set_default(color=manim.WHITE)
    manim.Rectangle.set_default(color=manim.WHITE)
    manim.SingleStringMathTex.set_default(color=manim.WHITE)
    manim.StreamLines.set_default(color=manim.WHITE)
    manim.TracedPath.set_default(stroke_color=manim.WHITE)
    manim.VectorField.set_default(color=manim.WHITE)

    manim.Text.set_default(color=manim.WHITE)
    manim.Tex.set_default(color=manim.WHITE)
    manim.MathTex.set_default(color=manim.WHITE)

    manim.Table.set_default(line_config={"color": manim.WHITE})

    manim.NumberPlane().set_default(
        background_line_style={
            "stroke_color": manim.GRAY,
        },
        x_axis_config={"stroke_color": manim.WHITE},
        y_axis_config={"stroke_color": manim.WHITE},
    )
