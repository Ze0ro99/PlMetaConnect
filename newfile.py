from PIL import Image, ImageEnhance
import os
import sys

# دالة للتحقق من تثبيت Pillow وإعطاء تعليمات إذا لم تكن مثبتة
try:
    from PIL import Image
except ImportError:
    print("مكتبة Pillow غير مثبتة!")
    print("افتح Terminal في Pydroid 3 واكتب: pip install Pillow")
    sys.exit(1)

def prepare_app_icon(input_path, output_dir, base_size=1024, sizes=None):
    # تحديد الأحجام الافتراضية إذا لم يتم توفير أحجام
    if sizes is None:
        sizes = [1024, 512, 256, 192, 180, 120, 96, 72, 48]

    # إنشاء المجلد الناتج إذا لم يكن موجودًا
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # فتح الصورة والتحقق من صحتها
    try:
        img = Image.open(input_path).convert("RGBA")
    except Exception as e:
        print(f"خطأ في فتح الصورة: {e}")
        print("تأكد من أن المسار صحيح: ", input_path)
        return

    # تحسين التباين والألوان
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.2)  # زيادة التباين بنسبة 20%
    enhancer = ImageEnhance.Color(img)
    img = enhancer.enhance(1.1)  # زيادة تشبع الألوان بنسبة 10%

    # تغيير الحجم إلى الحجم الأساسي
    img = img.resize((base_size, base_size), Image.LANCZOS)

    # حفظ الصورة الأساسية
    base_output_path = os.path.join(output_dir, f"app_icon_{base_size}x{base_size}.png")
    img.save(base_output_path, "PNG", quality=100)
    print(f"تم حفظ الصورة الأساسية: {base_output_path}")

    # إنشاء وتخزين جميع الأحجام الأخرى
    for size in sizes:
        if size == base_size:
            continue
        resized_img = img.resize((size, size), Image.LANCZOS)
        output_path = os.path.join(output_dir, f"app_icon_{size}x{size}.png")
        resized_img.save(output_path, "PNG", quality=100)
        print(f"تم حفظ الصورة بحجم {size}x{size}: {output_path}")

if __name__ == "__main__":
    # مسار الصورة بناءً على المعلومات التي قدمتها
    input_image_path = "/storage/emulated/0/Download/M_and_C_logo.png"

    # مسار الإخراج (سيتم إنشاء مجلد app_icons في نفس المجلد Download)
    output_directory = "/storage/emulated/0/Download/app_icons"

    # تشغيل السكربت أوتوماتيكيًا
    print("جاري معالجة الصورة...")
    prepare_app_icon(input_image_path, output_directory)
    print("تم الانتهاء!")