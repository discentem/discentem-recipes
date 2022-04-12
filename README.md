# discentem-recipes

## How to use Windows recipes (this may be out of date, main branch might work)

- Clone https://github.com/discentem/autopkg.git and switch to the `yaml_and_win branch`
- Clone https://github.com/discentem/discentem-recipes
- Set Autopkg cache dir as desired in `%appdata%\Local\Autopkg\config`
- Run `python .\Code\autopkg run chrome_windows.recipe.yaml -d C:\path\to\discentem-recipes`
- Profit!
