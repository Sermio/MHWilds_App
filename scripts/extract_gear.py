import os
from PIL import Image

def main():
    img_path = 'assets/imgs/sprites/gear.png'
    try:
        img = Image.open(img_path)
    except Exception as e:
        print(f"Error opening image: {e}")
        return

    tile_size = 64

    columns = {
        0: 'weapons/great-sword',
        1: 'weapons/sword-and-shield',
        2: 'weapons/dual-blades',
        3: 'weapons/long-sword',
        4: 'weapons/hammer',
        5: 'weapons/hunting-horn',
        6: 'weapons/lance',
        7: 'weapons/gunlance',
        8: 'weapons/switch-axe',
        9: 'weapons/charge-blade',
        10: 'weapons/insect-glaive',
        11: 'weapons/bow',
        12: 'weapons/light-bowgun',
        13: 'weapons/heavy-bowgun',
        14: 'armor/head',
        15: 'armor/chest',
        16: 'armor/arms',
        17: 'armor/waist',
        18: 'armor/legs',
        19: 'amulets'
    }

    for col, folder in columns.items():
        out_dir = f"assets/imgs/{folder}"
        os.makedirs(out_dir, exist_ok=True)
        
        for r in range(1, 13):
            # Crop box: (left, upper, right, lower)
            box = (col * tile_size, r * tile_size, (col + 1) * tile_size, (r + 1) * tile_size)
            tile = img.crop(box)
            
            # Check if empty
            if tile.getbbox() is not None:
                out_path = os.path.join(out_dir, f"rarity{r}.webp")
                tile.save(out_path, format="WEBP", lossless=True)

    print("Extraction complete for armors, weapons, and amulets in WEBP format!")

if __name__ == "__main__":
    main()
