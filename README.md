# discentem-recipes

## How to use Windows recipes

- Clone https://github.com/discentem/autopkg.git and switch to the `dev` branch
- Clone https://github.com/discentem/discentem-recipes
- Set Autopkg cache dir as desired in `%appdata%\Local\Autopkg\config` (json)
- Run `python .\Code\autopkg run chrome_windows.recipe.yaml -d C:\path\to\discentem-recipes`
- Profit!
