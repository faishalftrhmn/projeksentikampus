import gradio as gr
import requests

def analyze(text):
    if len(text.strip()) < 3:
        return "Komentar minimal 3 karakter", 0.0
    try:
        response = requests.post(
            'http://127.0.0.1:8000/api/v1/predict',
            json={'text': text},
            timeout=10
        )
        if response.status_code == 200:
            result = response.json()
            return result['label'], float(result['score'])
        return f"Error {response.status_code}", 0.0
    except Exception as e:
        return f"Koneksi gagal: {e}", 0.0

demo = gr.Interface(
    fn=analyze,
    inputs=gr.Textbox(label='Komentar'),
    outputs=[
        gr.Textbox(label='Label'),
        gr.Number(label='Skor')
    ],
    title='SentiKampus'
)

if __name__ == '__main__':
    demo.launch()