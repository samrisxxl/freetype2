-- Reference used: https://github.com/premake/premake-cookbook/blob/master/Recipes/freetype2/premake4.lua

project "freetype2"
    kind "StaticLib"
    language "C++"
    
   	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    -- FreeType: "it  is necessary to disable pre-compiled headers"
    -- This might be superflous since the project does not use a PCH
    flags { 'NoPCH' } 

    includedirs
    {
       "include"
    }
    
    files
    {
        -- base components (required)

        "src/base/ftsystem.c",
        "src/base/ftinit.c",
        "src/base/ftdebug.c",
        "src/base/ftbase.c",
        
        "src/base/ftbbox.c",       -- recommended, see <ftbbox.h>
        "src/base/ftglyph.c",      -- recommended, see <ftglyph.h>
        
        "src/base/ftbdf.c",        -- optional, see <ftbdf.h>
        "src/base/ftbitmap.c",     -- optional, see <ftbitmap.h>
        "src/base/ftcid.c",        -- optional, see <ftcid.h>
        "src/base/ftfstype.c",     -- optional
        "src/base/ftgasp.c",       -- optional, see <ftgasp.h>
        "src/base/ftgxval.c",      -- optional, see <ftgxval.h>
        "src/base/ftmm.c",         -- optional, see <ftmm.h>
        "src/base/ftotval.c",      -- optional, see <ftotval.h>
        "src/base/ftpatent.c",     -- optional
        "src/base/ftpfr.c",        -- optional, see <ftpfr.h>
        "src/base/ftstroke.c",     -- optional, see <ftstroke.h>
        "src/base/ftsynth.c",      -- optional, see <ftsynth.h>
        "src/base/fttype1.c",      -- optional, see <t1tables.h>
        "src/base/ftwinfnt.c",     -- optional, see <ftwinfnt.h>

        -- font drivers (optional; at least one is needed)

        "src/bdf/bdf.c",           -- BDF font driver
        "src/cff/cff.c",           -- CFF/OpenType font driver
        "src/cid/type1cid.c",      -- Type 1 CID-keyed font driver
        "src/pcf/pcf.c",           -- PCF font driver
        "src/pfr/pfr.c",           -- PFR/TrueDoc font driver
        "src/sfnt/sfnt.c",         -- SFNT files support
        
        -- (TrueType & OpenType)
        "src/truetype/truetype.c", -- TrueType font driver
        "src/type1/type1.c",       -- Type 1 font driver
        "src/type42/type42.c",     -- Type 42 font driver

        -- rasterizers (optional; at least one is needed for vector formats)

        "src/raster/raster.c",     -- monochrome rasterizer
        "src/smooth/smooth.c",     -- anti-aliasing rasterizer

        -- auxiliary modules (optional)

        "src/autofit/autofit.c",   -- auto hinting module
        "src/cache/ftcache.c",     -- cache sub-system (in beta)
        "src/gzip/ftgzip.c",       -- support for compressed fonts (.gz)
        "src/lzw/ftlzw.c",         -- support for compressed fonts (.Z)
        "src/bzip2/ftbzip2.c",     -- support for compressed fonts (.bz2)
        "src/gxvalid/gxvalid.c",   -- TrueTypeGX/AAT table validation
        "src/otvalid/otvalid.c",   -- OpenType table validation
        "src/psaux/psaux.c",       -- PostScript Type 1 parsing
        "src/pshinter/pshinter.c", -- PS hinting module
        "src/psnames/psnames.c"    -- PostScript glyph names support
    }
    
    defines
    {
        "VC_EXTRALEAN",
        "_CRT_SECURE_NO_WARNINGS",
        "FT2_BUILD_LIBRARY"    
    }    

    filter "system:windows"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"
        
        defines
        {
            "WIN32",
            "WIN32_LEAN_AND_MEAN"
        }    

        files
        {
            "src/winfonts/winfnt.c"   -- Windows FONT / FNT font driver
        }

    --[[ TO-DO: support mac
    filter "system:macosx"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"
        
        defines
        {
            
        }    

        files
        {
            "src/base/ftmac.c"        -- only on the Macintosh
        }
    ]]

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"
        defines 
        {
            "FT_DEBUG_LEVEL_ERROR",
            "FT_DEBUG_LEVEL_TRACE"
        }
        --targetname "freetype2411mt_d"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"
        defines
        {
            "NDEBUG"
        }
        --targetname "freetype2411mt"


--------------------------------------------------------------------------------------------

local prefix = _OPTIONS["prefix"] or "./dist/freetype2"
newaction 
{
    trigger     = "install",
    description = "Install freetype2 library",
    execute = function ()
        -- copy files, etc. here
        os.mkdir(prefix .. "/inc/freetype2");
        os.mkdir(prefix .. "/inc/freetype2/freetype");
        os.mkdir(prefix .. "/inc/freetype2/freetype/config");
        os.mkdir(prefix .. "/inc/freetype2/freetype/internal");
        os.mkdir(prefix .. "/inc/freetype2/freetype/internal/services");
        os.mkdir(prefix .. "/lib/x32");
        os.mkdir(prefix .. "/lib/x32/debug");
        os.mkdir(prefix .. "/lib/x32/release");
        os.mkdir(prefix .. "/lib/x64");
        os.mkdir(prefix .. "/lib/x64/debug");
        os.mkdir(prefix .. "/lib/x64/release");

        -- Copy header files
        files = os.matchfiles(  "include/*.h");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/inc/freetype2/" .. path.getname(f));
        end

        files = os.matchfiles(  "include/freetype/*.h");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/inc/freetype2/freetype/" .. path.getname(f));
        end
        
        files = os.matchfiles(  "include/freetype/config/*.h");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/inc/freetype2/freetype/config/" .. path.getname(f));
        end

        files = os.matchfiles(  "include/freetype/internal/*.h");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/inc/freetype2/freetype/internal/" .. path.getname(f));
        end

        files = os.matchfiles(  "include/freetype/internal/services/*.h");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/inc/freetype2/freetype/internal/services/" .. path.getname(f));
        end        
        
         -- Library files created in dist directory
        files = os.matchfiles("lib/x32/debug/*.*");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/lib/x32/debug/" .. path.getname(f));
        end

        files = os.matchfiles("lib/x32/release/*.*");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/lib/x32/release/" .. path.getname(f));
        end

        files = os.matchfiles("lib/x64/debug/*.*");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/lib/x64/debug/" .. path.getname(f));
        end

        files = os.matchfiles("lib/x64/release/*.*");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/lib/x64/release/" .. path.getname(f));
        end           
        
    end

}
