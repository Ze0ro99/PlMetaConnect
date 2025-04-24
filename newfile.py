#!/usr/bin/env python3
"""
PiMetaConnect App Icon Generator
================================
This script generates app icons for the PiMetaConnect project across multiple platforms (Android, iOS, PWA, and WebGL for Unity Metaverse).
Icons are organized in the project structure and optimized for use in client, server, and metaverse components.

Dependencies:
- Pillow (install via `pip install Pillow`)

Usage:
1. Place the input image in `client/assets/raw/M_and_C_logo.png`.
2. Update `input_image_path` and `output_base_dir` in `main()` if needed.
3. Run: `python scripts/generate_app_icons.py`

Output:
- Icons in `client/assets/icons/` (for frontend and PWA)
- Icons in `metaverse/Assets/Icons/` (for Unity WebGL)
- A manifest.json file in `client/public/` for PWA
- Updated README.md in `docs/` with icon previews
"""

import os
import sys
import json
from PIL import Image, ImageEnhance

# التحقق من تثبيت مكتبة Pillow
try:
    from PIL import Image
except ImportError:
    print("ERROR: Pillow library is not installed!")
    print("Run: pip install Pillow")
    sys.exit(1)

def enhance_image(image, contrast=1.2, brightness=1.0, sharpness=1.1):
    """
    Enhance the image by adjusting contrast, brightness, and sharpness.

    Args:
        image (PIL.Image): Input image
        contrast (float): Contrast enhancement factor (default: 1.2)
        brightness (float): Brightness enhancement factor (default: 1.0)
        sharpness (float): Sharpness enhancement factor (default: 1.1)

    Returns:
        PIL.Image: Enhanced image
    """
    try:
        enhancer = ImageEnhance.Contrast(image)
        image = enhancer.enhance(contrast)
        enhancer = ImageEnhance.Brightness(image)
        image = enhancer.enhance(brightness)
        enhancer = ImageEnhance.Sharpness(image)
        image = enhancer.enhance(sharpness)
        return image
    except Exception as e:
        print(f"ERROR: Failed to enhance image: {e}")
        return image

def generate_manifest_json(output_dir, icon_sizes):
    """
    Generate a manifest.json file for Progressive Web Apps (PWA).

    Args:
        output_dir (str): Output directory for manifest.json
        icon_sizes (list): List of icon sizes
    """
    manifest = {
        "name": "PiMetaConnect",
        "short_name": "PiMeta",
        "icons": [
            {
                "src": f"icons/app_icon_{size}x{size}.png",
                "sizes": f"{size}x{size}",
                "type": "image/png"
            } for size in icon_sizes
        ],
        "theme_color": "#ffffff",
        "background_color": "#ffffff",
        "display": "standalone",
        "start_url": "/"
    }
    try:
        manifest_path = os.path.join(output_dir, "manifest.json")
        with open(manifest_path, "w") as f:
            json.dump(manifest, f, indent=4)
        print(f"Generated: {manifest_path}")
    except Exception as e:
        print(f"ERROR: Failed to generate manifest.json: {e}")

def update_readme(readme_path, icon_sizes):
    """
    Update README.md with a section for app icons.

    Args:
        readme_path (str): Path to README.md
        icon_sizes (list): List of icon sizes to include
    """
    icon_section = """
## App Icon

The PiMetaConnect app icon represents the project's innovative vision for a decentralized metaverse.

<p align="center">
  <img src="../client/assets/icons/app_icon_512x512.png" alt="PiMetaConnect Icon" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);">
</p>

### Available Sizes

| Size | Preview |
|------|---------|
""" + "\n".join([f"| {size}x{size} | <img src=\"../client/assets/icons/app_icon_{size}x{size}.png\" width=\"100\"> |" for size in icon_sizes]) + "\n"

    try:
        with open(readme_path, "r", encoding="utf-8") as f:
            content = f.read()
        if "## App Icon" not in content:
            with open(readme_path, "a", encoding="utf-8") as f:
                f.write(icon_section)
            print(f"Updated: {readme_path}")
        else:
            print(f"README already contains App Icon section, skipping update.")
    except Exception as e:
        print(f"ERROR: Failed to update README: {e}")

def prepare_app_icon(input_path, output_base_dir, base_size=1024, quality=95, platform_configs=None):
    """
    Generate app icons for PiMetaConnect across multiple platforms.

    Args:
        input_path (str): Path to input image
        output_base_dir (str): Base directory for output
        base_size (int): Base icon size (default: 1024)
        quality (int): PNG quality (1-100, default: 95)
        platform_configs (dict): Platform-specific configurations
    """
    if not os.path.isfile(input_path):
        print(f"ERROR: Input image not found: {input_path}")
        return

    try:
        img = Image.open(input_path).convert("RGBA")
    except Exception as e:
        print(f"ERROR: Failed to open image: {e}")
        return

    img = enhance_image(img, contrast=1.2, brightness=1.0, sharpness=1.1)
    try:
        img = img.resize((base_size, base_size), Image.LANCZOS)
    except Exception as e:
        print(f"ERROR: Failed to resize image: {e}")
        return

    # إعدادات المنصات
    if platform_configs is None:
        platform_configs = {
            "client": {
                "sizes": [512, 256, 192, 180, 120],  # لـ PWA وfrontend
                "folder": "client/assets/icons",
                "prefix": "app_icon",
                "generate_manifest": True
            },
            "metaverse": {
                "sizes": [256, 128],  # لـ Unity WebGL
                "folder": "metaverse/Assets/Icons",
                "prefix": "metaverse_icon"
            },
            "android": {
                "sizes": [192, 144, 96, 72, 48],  # xxxhdpi, xxhdpi, xhdpi, hdpi, mdpi
                "folder": "client/android/mipmap",
                "prefix": "ic_launcher"
            },
            "ios": {
                "sizes": [180, 120, 1024, 152, 76],  # iOS sizes
                "folder": "client/ios/AppIcon",
                "prefix": "AppIcon"
            }
        }

    # حفظ الصورة الأساسية
    base_output_dir = os.path.join(output_base_dir, "base")
    os.makedirs(base_output_dir, exist_ok=True)
    base_output_path = os.path.join(base_output_dir, f"app_icon_{base_size}x{base_size}.png")
    try:
        img.save(base_output_path, "PNG", quality=quality)
        print(f"Generated base icon: {base_output_path}")
    except Exception as e:
        print(f"ERROR: Failed to save base icon: {e}")

    # إنشاء الأيقونات لكل منصة
    for platform, config in platform_configs.items():
        platform_dir = os.path.join(output_base_dir, config["folder"])
        os.makedirs(platform_dir, exist_ok=True)

        for size in config["sizes"]:
            try:
                resized_img = img.resize((size, size), Image.LANCZOS)
                output_path = os.path.join(platform_dir, f"{config['prefix']}_{size}x{size}.png")
                resized_img.save(output_path, "PNG", quality=quality)
                print(f"Generated {platform} icon: {output_path}")
            except Exception as e:
                print(f"ERROR: Failed to generate {platform} icon ({size}x{size}): {e}")

        # إنشاء manifest.json لـ PWA
        if platform == "client" and config.get("generate_manifest", False):
            generate_manifest_json(os.path.join(output_base_dir, "client/public"), config["sizes"])

    # تحديث README.md
    update_readme(os.path.join(output_base_dir, "docs/README.md"), platform_configs["client"]["sizes"])

def main():
    """
    Main function to run the icon generator for PiMetaConnect.
    """
    # مسارات المشروع
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    input_image_path = os.path.join(project_root, "client/assets/raw/M_and_C_logo.png")
    output_base_dir = project_root

    # إعدادات التخصيص
    settings = {
        "base_size": 1024,
        "quality": 95,
        "platform_configs": {
            "client": {
                "sizes": [512, 256, 192, 180, 120],
                "folder": "client/assets/icons",
                "prefix": "app_icon",
                "generate_manifest": True
            },
            "metaverse": {
                "sizes": [256, 128],
                "folder": "metaverse/Assets/Icons",
                "prefix": "metaverse_icon"
            },
            "android": {
                "sizes": [192, 144, 96, 72, 48],
                "folder": "client/android/mipmap",
                "prefix": "ic_launcher"
            },
            "ios": {
                "sizes": [180, 120, 1024, 152, 76],
                "folder": "client/ios/AppIcon",
                "prefix": "AppIcon"
            }
        }
    }

    print("Starting PiMetaConnect app icon generation...")
    prepare_app_icon(
        input_path=input_image_path,
        output_base_dir=output_base_dir,
        base_size=settings["base_size"],
        quality=settings["quality"],
        platform_configs=settings["platform_configs"]
    )
    print("App icon generation completed successfully!")

if __name__ == "__main__":
    main()
