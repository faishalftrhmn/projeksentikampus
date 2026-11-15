import streamlit as st
import requests

st.title('SentiKampus')

text = st.text_area('Tulis komentar layanan')

if st.button('Analisis'):
    if len(text.strip()) < 3:
        st.warning('Komentar minimal 3 karakter')
    else:
        try:
            response = requests.post(
                'http://127.0.0.1:8000/api/v1/predict',
                json={'text': text},
                timeout=10
            )
            if response.status_code == 200:
                result = response.json()
                st.metric('Label', result['label'])
                st.progress(float(result['score']))
            else:
                st.error(f"Error server: {response.status_code}")
        except Exception as e:
            st.error(f"Gagal koneksi ke API: {e}")