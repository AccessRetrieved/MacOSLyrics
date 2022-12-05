#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3

from tkinter import *
from tkinter.filedialog import askopenfilename
import os
import PyTouchBar as ptb
from shutil import copy
import tkmacosx
from pathlib import Path
from bs4 import BeautifulSoup as soup
import requests

root = Tk()
root.geometry('500x500+470+300')
root.tk.call("::tk::unsupported::MacWindowStyle", "style", root._w, "plain", "none")
root.attributes('-topmost', False)
root.attributes('-alpha', 0.9)
ptb.prepare_tk_windows(root)

filetypes = [
    ('Text Files', '*.txt')
]

with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/last_song.txt', 'w') as file: file.truncate(0)

ptb.set_customization_identifier("com.jerryhu.pytouchbar.touchbar", menu = True)

cmd = 'osascript {}'.format('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/files/nowplaying.scpt')
response = os.popen(cmd).read().replace('\n', '')
song = StringVar()
song.set(response)

counter = 1

floats = IntVar()
floats.set(1)

topmost = IntVar()
topmost.set(0)

success = []

def searches(s):
    success = []
    for dirpath, dirnames, files in os.walk(Path.home()):
        listdirs = os.listdir(dirpath)
        for i in listdirs:
            if s == '':
                pass
            else:
                if s.lower() in i.lower():
                    if i in success:
                        pass
                    else:
                        if i.endswith('.txt'):
                            success.append(os.path.join(dirpath, i))
                            pass
                        else:
                            pass
    return success

def update_song():
    cmd = 'osascript {}'.format('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/files/nowplaying.scpt')
    response = os.popen(cmd).read().replace('\n', '')
    song.set(response)
    display_title['text'] = ''
    if song.get() == '':
        display_title['text'] = '未在播放'
        song.set('未在播放')
    else:
        display_title['text'] = song.get()
        song_touch.text = '歌曲: {}'.format(song.get())
        pass

    root.after(ms=1000, func=update_song)

def playpauses(pause):
    global counter
    counter += 1

    if counter % 2 == 0:
        cmd = 'osascript -e \'tell application "Music" to play\''
        os.system(cmd)
    else:
        cmd = 'osascript -e \'tell application "Music" to pause\''
        os.system(cmd)
        pass

def add(s):
    display_lyrics.config(state=NORMAL)
    display_lyrics.delete(1.0, END)
    display_lyrics.tag_configure('center', justify='center')
    display_lyrics.insert(END, s)
    display_lyrics.tag_add('center', '1.0', 'end')
    display_lyrics.config(state=DISABLED)

def update_lyrics():
    with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/last_song.txt', 'r') as ins:
        file = str(ins.read())
        script = str(song.get())
        if file == script:
            pass
        else:
            if os.path.exists('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get())) == True:
                with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get())) as lyrics:
                    add(lyrics.read().replace('\n', '\n\n'))
                    with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/last_song.txt', 'w') as out:
                        out.write(song.get())
            else:
                add('\n\n\n\n\n没有找到相关歌词')

    root.after(ms=1500, func=update_lyrics)

def exits(exit): root.destroy()

def c(cu): ptb.customize()

def custo(): ptb.customize()

def close(fuck): os.system('osascript -e \'tell application "Music" to pause\''); root.withdraw()

def hide(): root.withdraw()

def show(): root.deiconify()

def update(): touch_lyrics.text = song.get(); root.after(ms=1000, func=update)

def check_float():
    if floats.get() == 1:
        root.attributes('-alpha', 0.9)
    else:
        root.attributes('-alpha', 1)

    root.after(ms=1000, func=check_float)

def check_topmost():
    if topmost.get() == 1:
        root.attributes('-topmost', True)
    else:
        root.attributes('-topmost', False)

    root.after(ms=1000, func=check_topmost)

def touch_l(touchbar_addlyrics):
    try:
        file = askopenfilename(filetypes=filetypes)
        copy(src=file, dst='/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()))
    except:
        pass

def nexts(nextsong):
    global seconds
    seconds = 0
    cmd = "osascript -e 'tell application \"Music\" to play playlist \"抖音歌曲\"'"
    os.system(cmd)

def browse():
    try:
        file = askopenfilename(filetypes=filetypes)
        copy(src=file, dst='/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()))
    except:
        pass

def search_win():
    search = Toplevel()
    search.geometry('700x550')
    search.title('搜索')
    search.attributes('-topmost', True)
    search.resizable(0, 0)

    def browse_now():
        browse()
        search.destroy()

    def check_playing():
        if song.get() == '未在播放':
            set.config(state=DISABLED)
            use_explorer.config(state=DISABLED)
        else:
            set.config(state=NORMAL)
            use_explorer.config(state=NORMAL)

        search.after(ms=1000, func=check_playing)

    def set_lyrics():
        try:
            file = results.get(results.curselection())
            copy(src=file, dst='/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()))
        except:
            pass

    def inse():
        response = searches(song.get())
        for i in response:
            results.insert(END, i)
        end = results.index('end')
        if end == 0:
            results.insert(END, '没有找到相关结果')
            set.config(state=DISABLED)
            use_explorer.config(state=DISABLED)
        else:
            idx = results.get(0, END).index(end)
            results.delete(idx)
            set.config(state=NORMAL)
            use_explorer.config(state=NORMAL)
            pass

        search.after(ms=2500, func=inse)

    def preview_lyrics(event):
        try:
            file = results.get(results.curselection())
            with open(file, 'r') as readfile:
                preview.config(state=NORMAL)
                preview.delete(1.0, END)
                display_lyrics.tag_configure('center', justify='center')
                preview.insert(END, readfile.read())
                preview.tag_add('center', '1.0', 'end')
                preview.config(state=DISABLED)
        except:
            pass

    def web():
        websearch = Toplevel()
        websearch.geometry('500x500')
        websearch.title('全网搜索')
        websearch.attributes('-topmost', True)
        websearch.resizable(0, 0)

        def insertp(string):
            previews.config(state=NORMAL)
            previews.tag_configure('center', justify='center')
            previews.insert(END, string)
            previews.tag_add('center', '1.0', 'end')
            previews.config(state=DISABLED)

        def auto_lyrics():
            try:
                songlist, songurl = find_songs(song.get())
                insertp(find_lyrics(songurl[0]))
            except:
                insertp('\n\n\n\n\n未找到相关歌词')

        def set_lyrics():
            try:
                songlist, songurl = find_songs(song.get())
                lyrics = find_lyrics(songurl[0])
                with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()), 'w') as writefile:
                    writefile.write(lyrics)
                    add(lyrics.replace('\n', '\n\n'))
                    with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/last_song.txt', 'w') as out:
                        out.write(song.get())
            except:
                insertp('\n\n\n\n\n未找到相关歌词')

        previews = Text(websearch, font=("Arial", 13), width=55)
        previews.place(relx=0.5, rely=0.45, anchor=CENTER)
        previews.config(state=DISABLED)

        set = tkmacosx.Button(websearch, text='设定', borderless=1, command=set_lyrics)
        set.place(relx=0.5, rely=0.95, anchor=CENTER)

        auto_lyrics()
        websearch.mainloop()

    song_title = Entry(search, justify=CENTER, font=("Arial", 15))
    song_title.delete(0, END)
    song_title.insert(0, song.get())
    song_title.config(state=DISABLED)
    song_title.place(relx=0.5, rely=0.05, anchor=CENTER)

    Label(search, text='搜索结果', font=("Arial", 13)).place(relx=0.5, rely=0.15, anchor=CENTER)

    results = Listbox(search, width=75, height=8, selectmode=SINGLE, justify=CENTER)
    results.place(relx=0.5, rely=0.325, anchor=CENTER)
    results.bind("<<ListboxSelect>>", preview_lyrics)

    preview = Text(search, width=85, height=14, font=("Arial", 14), state=DISABLED, cursor='arrow')
    preview.place(relx=0.5, rely=0.7, anchor=CENTER)

    use_explorer = tkmacosx.Button(search, text='选择本地文件', borderless=1, command=browse)
    use_explorer.place(relx=0.25, rely=0.95, anchor=CENTER)

    search_btn = tkmacosx.Button(search, text='开始本地搜索', borderless=1, command=lambda: [inse(), check_playing()])
    search_btn.place(relx=0.5, rely=0.85, anchor=CENTER)

    use_web = tkmacosx.Button(search, text='全网搜索', borderless=1, command=web)
    use_web.place(relx=0.5, rely=0.95, anchor=CENTER)

    set = tkmacosx.Button(search, text='设定', borderless=1, command=set_lyrics)
    set.place(relx=0.75, rely=0.95, anchor=CENTER)

    search.mainloop()

def settings(event):
    pref = Toplevel()
    pref.geometry('200x150')
    pref.title('设置')

    alpha = Checkbutton(pref, text='透明窗户', variable=floats)
    alpha.place(relx=0.5, rely=0.25, anchor=CENTER)

    top = Checkbutton(pref, text='置顶', variable=topmost)
    top.place(relx=0.5, rely=0.6, anchor=CENTER)

    pref.mainloop()

def searchss(touchbar_addlyrics):
    search = Toplevel()
    search.geometry('700x550')
    search.title('搜索')
    search.attributes('-topmost', True)
    search.resizable(0, 0)

    def browse_now():
        browse()
        search.destroy()

    def check_playing():
        if song.get() == '未在播放':
            set.config(state=DISABLED)
            use_explorer.config(state=DISABLED)
        else:
            set.config(state=NORMAL)
            use_explorer.config(state=NORMAL)

        search.after(ms=1000, func=check_playing)

    def set_lyrics():
        try:
            file = results.get(results.curselection())
            copy(src=file, dst='/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()))
        except:
            pass

    def inse():
        response = searches(song.get())
        for i in response:
            results.insert(END, i)
        end = results.index('end')
        if end == 0:
            results.insert(END, '没有找到相关结果')
            set.config(state=DISABLED)
            use_explorer.config(state=DISABLED)
        else:
            idx = results.get(0, END).index(end)
            results.delete(idx)
            set.config(state=NORMAL)
            use_explorer.config(state=NORMAL)
            pass

        search.after(ms=2500, func=inse)

    def preview_lyrics(event):
        try:
            file = results.get(results.curselection())
            with open(file, 'r') as readfile:
                preview.config(state=NORMAL)
                preview.delete(1.0, END)
                display_lyrics.tag_configure('center', justify='center')
                preview.insert(END, readfile.read())
                preview.tag_add('center', '1.0', 'end')
                preview.config(state=DISABLED)
        except:
            pass

    def web():
        websearch = Toplevel()
        websearch.geometry('500x500')
        websearch.title('全网搜索')
        websearch.attributes('-topmost', True)
        websearch.resizable(0, 0)

        def insertp(string):
            previews.config(state=NORMAL)
            previews.tag_configure('center', justify='center')
            previews.insert(END, string)
            previews.tag_add('center', '1.0', 'end')
            previews.config(state=DISABLED)

        def auto_lyrics():
            try:
                songlist, songurl = find_songs(song.get())
                insertp(find_lyrics(songurl[0]))
            except:
                insertp('\n\n\n\n\n未找到相关歌词')

        def set_lyrics():
            try:
                songlist, songurl = find_songs(song.get())
                lyrics = find_lyrics(songurl[0])
                with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/lyrics/{}.txt'.format(song.get()), 'w') as writefile:
                    writefile.write(lyrics)
                    add(lyrics.replace('\n', '\n\n'))
                    with open('/Users/jerryhu/Documents/Documents/Local_Python/lyrics/last_song.txt', 'w') as out:
                        out.write(song.get())
            except:
                insertp('\n\n\n\n\n未找到相关歌词')

        previews = Text(websearch, font=("Arial", 13), width=55)
        previews.place(relx=0.5, rely=0.45, anchor=CENTER)
        previews.config(state=DISABLED)

        set = tkmacosx.Button(websearch, text='设定', borderless=1, command=set_lyrics)
        set.place(relx=0.5, rely=0.95, anchor=CENTER)

        auto_lyrics()
        websearch.mainloop()

    song_title = Entry(search, justify=CENTER, font=("Arial", 15))
    song_title.delete(0, END)
    song_title.insert(0, song.get())
    song_title.config(state=DISABLED)
    song_title.place(relx=0.5, rely=0.05, anchor=CENTER)

    Label(search, text='搜索结果', font=("Arial", 13)).place(relx=0.5, rely=0.15, anchor=CENTER)

    results = Listbox(search, width=75, height=8, selectmode=SINGLE, justify=CENTER)
    results.place(relx=0.5, rely=0.325, anchor=CENTER)
    results.bind("<<ListboxSelect>>", preview_lyrics)

    preview = Text(search, width=85, height=14, font=("Arial", 14), state=DISABLED, cursor='arrow')
    preview.place(relx=0.5, rely=0.7, anchor=CENTER)

    use_explorer = tkmacosx.Button(search, text='选择本地文件', borderless=1, command=browse)
    use_explorer.place(relx=0.25, rely=0.95, anchor=CENTER)

    search_btn = tkmacosx.Button(search, text='开始本地搜索', borderless=1, command=lambda: [inse(), check_playing()])
    search_btn.place(relx=0.5, rely=0.85, anchor=CENTER)

    use_web = tkmacosx.Button(search, text='全网搜索', borderless=1, command=web)
    use_web.place(relx=0.5, rely=0.95, anchor=CENTER)

    set = tkmacosx.Button(search, text='设定', borderless=1, command=set_lyrics)
    set.place(relx=0.75, rely=0.95, anchor=CENTER)

    search.mainloop()

def find_songs(song_name):
    song_path = '+'.join(song_name.lower().split(' '))
    page = requests.get('https://search.azlyrics.com/search.php?q={}'.format(song_path))
    parsed = soup(page.content, 'html.parser')
    songs = parsed.find_all(class_ = 'text-left visitedlyr')

    if songs == []:
        return [], []
    else:
        b_tag_list = [song.find_all('b') for song in songs]
        song_list = [' / '.join(tag_content.get_text() for tag_content in b_tag) for b_tag in b_tag_list]
        song_urls = [song.find('a', href = True)['href'] for song in songs]
        
        return song_list, song_urls

def find_lyrics(lyrics_url):
    lyrics_page = requests.get(lyrics_url)
    parsed_lyrics_page = soup(lyrics_page.content, 'html.parser')
    lyrics = parsed_lyrics_page.find_all('div', class_ = None)[1].get_text().strip()
    return lyrics

display_title = Label(root, text=song.get(), font=("Arial", 17))
display_title.place(relx=0.5, rely=0.1, anchor=CENTER)

touch_lyrics = ptb.TouchBarItems.Label(text=song.get(), id="label", customization_label='歌曲名字', customization_mode=ptb.CustomizationMode.allowed)
song_touch = ptb.TouchBarItems.Label(text='歌曲: ' + song.get(), id="llabel", customization_label='歌曲', customization_mode=ptb.CustomizationMode.allowed)

display_lyrics = Text(root, font=("Arial", 13), width=40, cursor='arrow')
display_lyrics.place(relx=0.5, rely=0.55, anchor=CENTER)
add('没有找到相关歌词')
display_lyrics.config(state=DISABLED)

cu = ptb.TouchBarItems.Button(title='个性化', action=c, id="btn", customization_label="个性化控制栏", customization_mode=ptb.CustomizationMode.allowed)

sp = ptb.TouchBarItems.Space.Flexible(customization_mode=ptb.CustomizationMode.allowed)

playpause = ptb.TouchBarItems.Button(title='播放/暂停', action=playpauses, id="button", customization_label="播放/暂停", customization_mode=ptb.CustomizationMode.allowed)

fuck = ptb.TouchBarItems.Button(title='👻 Fuck!', action=close, id="bbtn", customization_label='Fuck! 隐藏窗户', customization_mode=ptb.CustomizationMode.allowed, color=(167, 39, 39, 1))

touchbar_addlyrics = ptb.TouchBarItems.Button(title='添加歌词', action=searchss, id="bbbtn", customization_label="添加歌词", customization_mode=ptb.CustomizationMode.allowed)

nextsong = ptb.TouchBarItems.Button(title='下一首', action=nexts, customization_label='下一首', customization_mode=ptb.CustomizationMode.allowed)

exit_hint = ptb.TouchBarItems.Label(text='确定退出?  ')
exit_btn = ptb.TouchBarItems.Button(title='退出', color=ptb.Color.red, action=exits)

exit_pop = ptb.TouchBarItems.Popover([exit_hint, exit_btn], title='退出')

menubar = Menu(root, tearoff=0)
filemenu = Menu(menubar)
filemenu.add_command(label='退出', command=root.destroy)

viewmenu = Menu(menubar)
viewmenu.add_command(label='Fuck!', command=hide)
viewmenu.add_command(label='Show!', command=show)
viewmenu.add_separator()
viewmenu.add_command(label="个性化控制栏", command=custo)

lyricsmenu = Menu(menubar)
lyricsmenu.add_command(label='搜索歌词', command=search_win)

menubar.add_cascade(label='文件', menu=filemenu)
menubar.add_cascade(label='查看', menu=viewmenu)
menubar.add_cascade(label='歌词', menu=lyricsmenu)

update_song()
update_lyrics()
update()
check_float()
check_topmost()
ptb.set_touchbar([touchbar_addlyrics, sp, song_touch, sp, nextsong], esc_key=exit_pop, define=[playpause, fuck, touch_lyrics, touchbar_addlyrics, nextsong])
root.config(menu=menubar)
root.bind("<Command-,>", settings)
root.mainloop()