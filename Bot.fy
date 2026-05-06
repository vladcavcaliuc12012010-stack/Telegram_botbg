import os
import random
from datetime import datetime, timedelta
import pytz
from telegram import Update
from telegram.ext import ApplicationBuilder, MessageHandler, CommandHandler, filters, ContextTypes

TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    mesaj = (
        "Bună ziua! 👋\n\n"
        "Acesta este botul pentru bilete electronice de transport public.\n\n"
        "📋 Cum se folosește:\n"
        "Trimiteți numărul de bord al autobuzului (ex: 1, 23, 107) și veți primi un bilet electronic valid 1 oră.\n\n"
        "💰 Prețul unui bilet: 7 MDL\n\n"
        "Scrieți numărul de bord pentru a cumpăra biletul:"
    )
    await update.message.reply_text(mesaj)

async def bilet(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text
    if text.isdigit():
        cod = text
        tz = pytz.timezone("Europe/Chisinau")
        now = datetime.now(tz)
        final = now + timedelta(hours=1)
        nr_bilet = random.randint(10000000, 99999999)
        mesaj = f"""Bilet electronic nr.
{nr_bilet}

{now.strftime("%d.%m.%Y")}
Valabil 1 oră (de la {now.strftime("%H:%M")} până la {final.strftime("%H:%M")})

Preț 7 MDL
Număr de bord {cod}
"""
        await update.message.reply_text(mesaj)
    else:
        await update.message.reply_text("⚠️ Vă rugăm să trimiteți doar numărul de bord (cifre, ex: 23).")

app = ApplicationBuilder().token(TOKEN).build()
app.add_handler(CommandHandler("start", start))
app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, bilet))

print("Bot pornit...")
app.run_polling()
